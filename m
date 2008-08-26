Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbYHZRtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbYHZRtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbYHZRtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:49:33 -0400
Received: from ag-out-0708.google.com ([72.14.246.246]:24207 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbYHZRtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:49:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=aDyY32AhD/Z7ItbpyORwVhEdK273oi3PDqkpMwE1BysNzxEhvlhI++WRdjhktSiSiq
         cysVr/YxPTrCdnPAykKG5WyB0zasc3TAqHZqqWgDX/V9c4U3k4LDlkkne/gtRf/auMSP
         qtUtY69JgSBKVdli/NUJLtIEh/a0mOEM3kXIQ=
Message-ID: <48B441E1.5090304@gmail.com>
Date: Tue, 26 Aug 2008 19:48:17 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, v9fs-developer@lists.sourceforge.net,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 2/2] poll: allow f_op->poll to sleep
References: <48B40BD4.7040004@kernel.org> <48B40C2F.3050700@gmail.com> <alpine.LFD.1.10.0808260954040.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808260954040.3363@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Takashi Iwai)

Hello, Linus.

Linus Torvalds wrote:
>> This patch converts poll/select to use custom wake up function and use
>> separate triggered variable to synchronize against wake up events.
>> The only added overhead is an extra function call during wake up and
>> negligible.
> 
> I don't really see the point.
> 
> poll() isn't allowed to sleep for many reasons. Some are technical. But 
> the most obvious one is that a sleeping "poll()" is totally against the 
> whole point of polling in the first place!
> 
> So is there some big conceptual reason to change how poll() has always 
> worked?

No big conceptual reason at all.  I was trying to implement poll for
FUSE so that character device can be implemented in userspace such that
/dev/dsp can be routed to pulseaudio (or whatever) and for userland
filesystem, non-sleep poll just couldn't be made to work and there
didn't seem to be no big reason for poll not being able to sleep, so...

The OSS sound routing is probably a bit too late but the exclusion
between OSS and the modern sound system is still quite annoying and for
simple sound apps OSS interface is just much simpler as it's just normal
file IOs and fully contained in kernel (e.g. arch-um host sound support).

> If you worry about debuggability, then we could just add a 
> 
> 	preempt_enable();
> 	..
> 	preempt_disable();
> 
> around the poll calls (purely for catching errors) to get a big warning if 
> somebody tries to call a sleepable function.

Yeap, that will be a nice debug option to have if this patch gets NACKed.

Thanks.

-- 
tejun
