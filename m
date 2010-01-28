Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073Ab0A1C2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0A1C2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 21:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836Ab0A1C2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 21:28:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:48347 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab0A1C2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 21:28:22 -0500
Date: Thu, 28 Jan 2010 13:28:12 +1100
From: Neil Brown <neilb@suse.de>
To: Milan Broz <mbroz@redhat.com>
Cc: Marti Raudsepp <marti@juffo.org>,
       "Ing. Daniel =?UTF-8?B?Um96c255w7M=?=" <daniel@rozsnyo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: bio too big - in nested raid setup
Message-ID: <20100128132812.2d01f211@notabene>
In-Reply-To: <4B5DE2A9.4030500@redhat.com>
References: <4B5C963D.8040802@rozsnyo.com>
	<5ec358371001250725l40b13060md880001c96be165f@mail.gmail.com>
	<4B5DE2A9.4030500@redhat.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 19:27:53 +0100
Milan Broz <mbroz@redhat.com> wrote:

> On 01/25/2010 04:25 PM, Marti Raudsepp wrote:
> > 2010/1/24 "Ing. Daniel Rozsnyó" <daniel@rozsnyo.com>:
> >> Hello,
> >>  I am having troubles with nested RAID - when one array is added to the
> >> other, the "bio too big device md0" messages are appearing:
> >>
> >> bio too big device md0 (144 > 8)
> >> bio too big device md0 (248 > 8)
> >> bio too big device md0 (32 > 8)
> > 
> > I *think* this is the same bug that I hit years ago when mixing
> > different disks and 'pvmove'
> > 
> > It's a design flaw in the DM/MD frameworks; see comment #3 from Milan Broz:
> > http://bugzilla.kernel.org/show_bug.cgi?id=9401#c3
> 
> Hm. I don't think it is the same problem, you are only adding device to md array...
> (adding cc: Neil, this seems to me like MD bug).
> 
> (original report for reference is here http://lkml.org/lkml/2010/1/24/60 )

No, I think it is the same problem.

When you have a stack of devices, the top level client needs to know the
maximum restrictions imposed by lower level devices to ensure it doesn't
violate them.
However there is no mechanism for a device to report that its restrictions
have changed.
So when md0 gains a linear leg and so needs to reduce the max size for
requests, there is no way to tell DM, so DM doesn't know.  And as the
filesystem only asks DM for restrictions, it never finds out about the
new restrictions.

This should be fixed by having the filesystem not care about restrictions,
and the lower levels just split requests as needed, but that just hasn't
happened....

If you completely assemble md0 before activating the LVM stuff on top of it,
this should work.

NeilBrown
