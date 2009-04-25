Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZDYU3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZDYU3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 16:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZDYU3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 16:29:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42926 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZDYU3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 16:29:09 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, npiggin@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090425012020.457460929@suse.de>
	<20090425041829.GX8633@ZenIV.linux.org.uk>
	<20090425080143.GA29033@infradead.org>
	<m1tz4ctuu7.fsf@fess.ebiederm.org>
	<20090425193133.GB8633@ZenIV.linux.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 25 Apr 2009 13:29:01 -0700
In-Reply-To: <20090425193133.GB8633@ZenIV.linux.org.uk> (Al Viro's message of "Sat\, 25 Apr 2009 20\:31\:33 +0100")
Message-ID: <m11vrgscj6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, npiggin@suse.de, hch@infradead.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4960]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [patch 00/27] [rfc] vfs scalability patchset
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sat, Apr 25, 2009 at 12:08:16PM -0700, Eric W. Biederman wrote:
>
>> Can we?  My first glance at that code I asked myself if we could examine
>> i_writecount, instead of going to the file. My impression was that we
>> were deliberately only counting persistent write references from files
>
> No, there's nothing deliberate about that.  The code is simply wrong;
> some of that crap had been fixed with mnt_want_write series, but
> the rest...
>
>> instead of transient write references.  As only the persistent write
>> references matter.  Transient write references can at least in theory
>> be flushed as the filesystem is remounting read-only.
>
> No.  It's far too painful to do and no fs is doing that.  You are looking
> for deliberate behaviour in a place where we have a half-fixed pile of races.

I didn't trace it all of the way through but this comment in
ext3_remount fooled me:

	/*
	 * We have to unlock super so that we can wait for
	 * transactions.
	 */

Which was enough to think it might have been deliberate behavior so I figured
it was worth asking.  It looked like the journal commit logic could have
been doing the blocking magic to wait on ongoing truncates and the like.

Still even it was deliberate it is the job of user space to remove all writers
before we remount read-only, and making the guarantee that we pass to the
filesystems that the fs is read-only stronger should not hurt anything.

Eric
