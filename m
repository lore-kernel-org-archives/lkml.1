Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYKXMZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYKXMZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYKXMZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:25:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:4438 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbYKXMZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:25:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LMxep1xz6ET0w3TpBmgXyeLQfQzzSozjkmLQMRv92f1Wo3tbz1V7oyKEzalXGK9Iw1
         qA7CLK81ag2P1ahSqShMfu6R4FvL+VNBqpw+1wAHjrAJc8KBqrHYikbx4fJ05/nTacIX
         prU0u/cPOe2X3DEwlED2A1NP1FbdIK2MbqC9w=
From: Eric Lacombe <goretux@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [x86] do_arch_prctl
Date: Mon, 24 Nov 2008 13:24:53 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-7-generic; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200811181835.07360.goretux@gmail.com> <4924AA4E.4090001@goop.org> <200811200122.07694.goretux@gmail.com>
In-Reply-To: <200811200122.07694.goretux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811241324.54606.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Does the "doit case" (line 822 in ARCH_GET_FS, function do_arch_prctl) exist 
for performance reasons? Else, why "task->thread.fs" (line 824) does not 
contain the fs base in the "doit case"?

Can someone explain _precisely_ the lines 835 through 838 (ARCH_GET_GS)?
(I thought that just the line 836 was sufficient, but I 
obviously miss the case where MSR_KERNEL_GS_BASE does not reflect the value 
requested)

Thanks again for all your previous answers.

	Eric

828 case ARCH_GET_GS: {
829                 unsigned long base;
830                 unsigned gsindex;
831                 if (task->thread.gsindex == GS_TLS_SEL)
832                         base = read_32bit_tls(task, GS_TLS);
833                 else if (doit) {
834                         asm("movl %%gs,%0" : "=r" (gsindex));
835                         if (gsindex)
836                                 rdmsrl(MSR_KERNEL_GS_BASE, base);
837                         else
838                                 base = task->thread.gs;
839                 }
840                 else
841                         base = task->thread.gs;
842                 ret = put_user(base, (unsigned long __user *)addr);
843                 break;
844         }

---

817         case ARCH_GET_FS: {
818                 unsigned long base;
819                 if (task->thread.fsindex == FS_TLS_SEL)
820                         base = read_32bit_tls(task, FS_TLS);
821                 else if (doit)
822                         rdmsrl(MSR_FS_BASE, base);
823                 else
824                         base = task->thread.fs;
825                 ret = put_user(base, (unsigned long __user *)addr);
826                 break;
827         }

