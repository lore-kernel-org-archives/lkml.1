Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbYFLMgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbYFLMgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761234AbYFLMfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:35:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:61166 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761190AbYFLMfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:35:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maynard Johnson <maynardj@us.ibm.com>
Subject: Re: [PATCH] Version 3: Reworked Cell OProfile: SPU mutex lock fix
Date: Thu, 12 Jun 2008 14:31:52 +0200
User-Agent: KMail/1.9.9
Cc: Carl Love <cel@us.ibm.com>, acjohnso <acjohnso@us.ibm.com>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       cbe-oss-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>
References: <1213139954.6763.244.camel@carll-linux-desktop> <200806111452.46619.arnd@arndb.de> <484FE6EA.2060403@us.ibm.com>
In-Reply-To: <484FE6EA.2060403@us.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806121431.53596.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18BdDA3yaNSIxqyT/Y3Zs/tAM24YUhxFmY0KiZ
 LR0H9wtRJKXYUEqwtxG+WKVFza7UJL/RApCE+itdMsDVad9eAI
 nyId2MaX+zZwzzDbb/mHQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008, Maynard Johnson wrote:

> >
> > I like the approach in general, but would prefer to have it more generic,
> > so that other subsystems can use the same infrastructure if necessary:
> >   
> I believe Carl's thoughts on implementation would result in
> model-specific buffer create/destroy routines, to be invoked by the
> generic routine.  This would give the flexibility for architectures to
> implement their own unique buffering mechanism.  I don't think it would
> be worthwhile to go beyond this level in trying to build some generic
> mechanism since the generic mechanism already exists and has been
> sufficient for all other architectures.

Well, the amount of code should be the same either way. We currently
have an interface between the cpu_buffer and its users, which the
interface between the event_buffer and the cpu_buffer is private
to the oprofile layer.

The logical extension of this would be to have another buffer in
common oprofile code, and have its users in the architecture code,
rather than interface the architecture with the private event_buffer.

> > I think the dependency on the size of the per cpu buffers is a bit
> > artificial. How about making this independently tunable with
> > another oprofilefs file and a reasonable default?
> > You could either create the extra files in oprofile_create_files
> > or in oprofile_ops.create_files.
> >   
> With the right scaling factor, we should be able to avoid the buffer
> overflows for the most part.  Adding a new file in oprofilefs for an
> arch-specific buffer size would have to be documented on the user side,
> as well as providing a new option on the opcontrol command to adjust the
> value.  Granted, the system-wide buffer that Carl is proposing for Cell
> clashes with the "cpu buffer" construct, but some other architecture in
> the future may want to make use of this new model-specific buffer
> management routines and perhaps their buffers *would* be per-cpu.  I'm
> not sure there  would be much value add in exposing this implementation
> detail to the user as long as we can effectively use the existing user
> interface mechanism for managing buffer size.

But we're already exposing the implementation detail for the cpu buffers,
which are similar enough, just not the same. Since the file and opcontrol
option are called cpu-buffer-size, its rather unobvious how this should
control the size of a global buffer. As I mentioned, with a reasonable
default, you should not need to tune this anyway.
Changing opcontrol is a real disadvantage, but if a user needs to tune
this without a new opcontrol tool, it's always possible to directly
write to the file system.

> > As a general design principle, I'd always try to have locks close
> > to the data. What this means is that I think the SPU_BUFFER should
> > be in drivers/oprofile, similar to the cpu_buffer. In that case,
> > it may be better to change the name to something more generic, e.g.
> > aux_buffer.
> >   
> I agree -- in principle -- however, I really don't think a system-wide
> buffer is something we want to put into generic code.  It is not
> generally useful.  Also, putting this new code in drivers/oprofile would
> not fit well with the general technique of adding model-specific
> function pointers to 'struct oprofile_operations'.

> This assumes we can get the oprofile maintainer to review and comment on
> the new patch, which has been difficult to do lately.  I agree that we
> should not avoid making changes to common code when there's a good
> justification for it, but I would say that this is not such a case.

You have to change the oprofile code either way, because the existing
interface is not sufficient. However, there is no point in trying to do
a minimal change to the existing code when a larger change clearly gives
us a better resulting code.

	Arnd <><
