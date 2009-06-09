Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbZFIGba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbZFIGba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZFIGbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:31:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33996 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZFIGbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:31:19 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org,
       adobriyan@gmail.com, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de,
       akpm@linux-foundation.org, hch@infradead.org
References: <m1skkf761y.fsf@fess.ebiederm.org>
	<m1oct739xu.fsf@fess.ebiederm.org>
	<20090606080334.GA15204@ZenIV.linux.org.uk>
	<E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu>
	<20090608162913.GL8633@ZenIV.linux.org.uk>
	<E1MDhxh-0004nz-Qm@pomaz-ex.szeredi.hu>
	<20090608175018.GM8633@ZenIV.linux.org.uk>
	<E1MDuEI-0006BC-1C@pomaz-ex.szeredi.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 08 Jun 2009 23:31:16 -0700
In-Reply-To: <E1MDuEI-0006BC-1C@pomaz-ex.szeredi.hu> (Miklos Szeredi's message of "Tue\, 09 Jun 2009 07\:50\:38 +0200")
Message-ID: <m1tz2pyl3f.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org, npiggin@suse.de, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 0/23] File descriptor hot-unplug support v2
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Mon, 8 Jun 2009, Al Viro wrote:
>> On Mon, Jun 08, 2009 at 06:44:41PM +0200, Miklos Szeredi wrote:
>> 
>> > I'm still not getting what the problem is.  AFAICS file operations are
>> > either
>> > 
>> >  a) non-interruptible but finish within a short time or
>> >  b) may block indefinitely but are interruptible (or at least killable).
>> > 
>> > Anything else is already problematic, resulting in processes "stuck in
>> > D state".
>> 
>> Welcome to reality...
>> 
>> * bread() is non-interruptible
>> * so's copy_from_user()/copy_to_user()
>
> And why should revoke(2) care?  Just wait for the damn thing to
> finish.  Why exactly do these need to be interruptible?

Agreed.  I expect the data size is going to be a page or less.  Which
is at most 64K on some weird architectures.  I think that counts as a
short time waiting for disk I/O.  Baring thrashing.

> Okay, if we want revoke or umount -f to be instantaneous then all that
> needs to be taken care of.  But does it *need* to be?

Good question.  I wonder what umount -f needs when we yank out a usb drive.

> My idea of revoke is something like below:
>
>   - make sure no new operations are started on the file
>   - check state of tasks for ongoing operations, if interruptible send signal

    Figuring out who to send a signal to is tricky.  Still it should be doable
    in the common case.

>   - wait for all pending operations to finish
>   - kill file

Eric
