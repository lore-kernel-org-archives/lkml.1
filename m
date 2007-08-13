Return-Path: <linux-kernel-owner+w=401wt.eu-S1031590AbXHMNiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031590AbXHMNiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030400AbXHMJxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:53:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:33928 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030393AbXHMJxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:53:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QVwTXt7hKTzxaFbWUF4KdU0onZ80VP15vW48VfX466fTY9+inTQ1WrtvP8ZNswCqUGFoQ9J5IkP1ILzdhBCh55ug+u3vJ4CDC09Nc2/OmDs2g7Edu5NDL6F02KOE0SSNm49BiE79x4jD1hFAGC6W1OqOVe0d7fFeFYPr2T3U0ck=
Date: Mon, 13 Aug 2007 13:53:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Moore <paul.moore@hp.com>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Vance <cvance@nai.com>, Wayne Salamon <wsalamon@nai.com>,
       James Morris <jmorris@redhat.com>, dgoeddel@trustedcs.com,
       Fengguang Wu <fengguang.wu@gmail.com>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070813095302.GA7239@cvg>
References: <20070812141905.4ee423b9@the-village.bc.nu> <386927758.14086@ustc.edu.cn> <20070812161744.200d4252@the-village.bc.nu> <20070812162143.GA7202@cvg> <20070813002342.GA6908@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813002342.GA6908@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[WU Fengguang - Mon, Aug 13, 2007 at 08:23:42AM +0800]
| On Sun, Aug 12, 2007 at 08:21:43PM +0400, Cyrill Gorcunov wrote:
| > [Alan Cox - Sun, Aug 12, 2007 at 04:17:44PM +0100]
| > | Try this (it compiles but isnt tested). Its a weekend here, the sun is
| > | shining, the beach is a short walk, and I have more interesting things to
| > | do right now 8)
| > | 
| > | 
| [...]
| > | -int __vm_enough_memory(long pages, int cap_sys_admin)
| > | +int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
| > |  {
| > |  	unsigned long free, allowed;
| > |  
| > | @@ -166,7 +166,7 @@
| > |  
| > |  	/* Don't let a single process grow too big:
| > |  	   leave 3% of the size of this process for other processes */
| > | -	allowed -= current->mm->total_vm / 32;
| > | +	allowed -= mm->total_vm / 32;
| > 
| > So mm->total_vm is 0 for __bprm_mm_init case. Is that ok? Or I miss
| > something?
| 
| Yeah, Alan adds mm to the interfaces and leaves us the question of
| "what mm to pass in when current->mm == NULL?" ;)
| 

Well, as I see, it seems the Alan's patch is correct. We pass
newly created mm to security_vm_enough_memory_mm() and get no errors
here even for overcommit = 2. But my question was that mm->total_vm
= 0 for this case and that is probably valid too I think. What about
the thing you pointed about? Well I think security_vm_enough_memory
should never be called from kernel thread (we have secrurity_vm_enough_memory_mm
for this). But I will check it more closely. Dont get me wrong - I'm not
VMM expert and may do errors ;)

		Cyrill

