Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZD1Lcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZD1Lcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760417AbZD1LcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:32:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45250 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668AbZD1LcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:32:19 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, npiggin@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20090425012020.457460929@suse.de>
	<20090425041829.GX8633@ZenIV.linux.org.uk>
	<20090425080143.GA29033@infradead.org>
	<20090425080649.GA8633@ZenIV.linux.org.uk>
	<20090428090930.GA14638@infradead.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 28 Apr 2009 04:32:13 -0700
In-Reply-To: <20090428090930.GA14638@infradead.org> (Christoph Hellwig's message of "Tue\, 28 Apr 2009 05\:09\:30 -0400")
Message-ID: <m1d4axggjm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: hch@infradead.org, peterz@infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, npiggin@suse.de, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christoph Hellwig <hch@infradead.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4991]
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

Christoph Hellwig <hch@infradead.org> writes:

> On Sat, Apr 25, 2009 at 09:06:49AM +0100, Al Viro wrote:
>> Maybe...  What Eric proposed is essentially a reuse of s_list for per-inode
>> list of struct file.  Presumably with something like i_lock for protection.
>> So that's not a conflict.
>
> But what do we actually want it for?  Right now it's only used for
> ttys, which Nick has split out, and for remount r/o.  For the normal
> remount r/o case it will go away once we have proper per-sb writer
> counts.  And the fource remount r/o from sysrq is completely broken.

The plan is to post my updated patches tomorrow after I have slept.

What I am looking at is that the tty layer is not a special case.  Any
subsystem that wants any revoke kind of functionality starts wanting
the list of files that are open.  My current list where we have
something like this is: sysfs, proc, sysctl, tun, tty, sound.

I am in the process of generalizing the handling and bringing all of this
into the VFS, where we only need to maintain it once, and can see
clearly what is going on so we can optimize it.

For that I essentially need per inode lists of files.  Devices don't
have inodes but the usually have some kind of equivalent like the
tty struct we can attach inodes to.

It looks like what I have could pretty easily be used to implement
mount -f except for some weird cases like nfsd where the usual vfs
rules are not followed.  In particular things vfs_sync are a pain.

> A while ago Peter had patches for files_lock scalability that went even
> further than Nicks, and if I remember the arguments correctly just
> splitting the lock wasn't really enough and he required additional
> batching because there just were too many lock roundtrips.  (Peter, do
> you remember the defails?)

I would love to hear what the issues are.  Since everyone is worried
about performance and contention I have gone ahead and made the
files_list_lock per inode in my patches.  We will see how well that works.
My goals has simply been to add functionality without making a significant
change in performance on the current workloads.

Eric
