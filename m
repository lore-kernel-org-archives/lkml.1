Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbXAWEnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbXAWEnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 23:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbXAWEnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 23:43:46 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52431 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbXAWEnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 23:43:45 -0500
Message-ID: <45B59218.4040201@hitachi.com>
Date: Tue, 23 Jan 2007 13:42:00 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, james.bottomley@steeleye.com,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] binfmt_elf: core dump masking support
References: <457FA840.5000107@hitachi.com> 
    <20061213132358.ddcaaaf4.akpm@osdl.org> <20061220154056.GA4261@ucw.cz> 
    <45A2EADF.3030807@hitachi.com> <20070109143912.GC19787@elf.ucw.cz> 
    <45A74B89.4040100@hitachi.com> <20070114200157.GA2582@elf.ucw.cz> 
    <45B01387.7010207@hitachi.com> <20070119004548.GE10351@elf.ucw.cz> 
    <45B42194.3050601@hitachi.com> <20070122100610.GC16309@elf.ucw.cz>
In-Reply-To: <20070122100610.GC16309@elf.ucw.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>>>(run echo 1 > coremask, echo 0 > coremask in a loop while dumping
>>>core. Do you have enough locking to make it work as expected?)
>>
>>Currently, any lock isn't acquired.  But I think the kernel only
>>have to preserve the coremask setting in a local variable at the
>>begining of core dumping.  I'm going to do this in the next version.
> 
> No, I do not think that is enough. At minimum, you'd need atomic_t
> variable. But I'd recomend against it. Playing with locking is tricky.

Why do you think it is not enough?  I think that any locking is not
needed.
My design principle is that the core dump routine is controlled by
the bitmask which was assigned to the dumping process at the time of
starting core dump. So if a coremask setting is changed while
core dumping, the change doesn't affect current dumping process.
This can be implemented as follows:

   core_dump_start:
  unsigned int mask = current->mm->coremask;
  for each VMA {
    write a header which depends on the result of maydump(vma, mask)
  }
  for each VMA {
    write a body which depends on the result of maydump(vma, mask)
  }

NOTE:
  maydump() is the central function, which decides whether a given
  VMA should be dumped or not.

What do you think about this?


Best regards,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory


