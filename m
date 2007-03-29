Return-Path: <linux-kernel-owner+w=401wt.eu-S1030502AbXC2RR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502AbXC2RR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030493AbXC2RR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:17:28 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33206 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030489AbXC2RR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:17:26 -0400
Date: Thu, 29 Mar 2007 10:10:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Subject: Re: Interface for the new fallocate() system call
Message-Id: <20070329101010.7a2b8783.akpm@linux-foundation.org>
In-Reply-To: <20070329115126.GB7374@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
	<20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
	<20070317111036.GC29931@parisc-linux.org>
	<20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 17:21:26 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:

> Hello,
> 
> We need to come up with the best possible layout of arguments for the
> fallocate() system call. Various architectures have different
> requirements for how the arguments should look like. Since the mail
> chain has become huge, here is the summary of various inputs received
> so far.
> 
> Platform: s390
> --------------
> s390 prefers following layout:
> 
>    int fallocate(int fd, loff_t offset, loff_t len, int mode)
> 
> For details on why and how "int, int, loff_t, loff_t" is a problem on
> s390, please see Heiko's mail on 16th March. Here is the link:
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg133595.html
> 
> Platform: ppc, arm
> ------------------
> ppc (32 bit) has a problem with "int, loff_t, loff_t, int" layout,
> since this will result in a pad between fd and offset, making seven
> arguments total - which is not supported by ppc32. It supports only
> 6 arguments. Thus the desired layout by ppc32 is:
> 
>    int fallocate(int fd, int mode, loff_t offset, loff_t len)
> 
> Even ARM prefers above kind of layout. For details please see the
> definition of sys_arm_sync_file_range().

This is a clean-looking option.  Can s390 be changed to support seven-arg
syscalls?

> Option of loff_t => high u32 + low u32
> --------------------------------------
> Matthew and Russell have suggested another option of breaking each
> "loff_t" into two "u32"s. This will result in 6 arguments in total.
> 
> Following think that this is a good alternative:
> Matthew Wilcox, Russell King, Heiko Carstens
> 
> Following do not like this idea:
> Chris Wedgwood

It's a bit weird-looking, but the six-32-bit-args approach is simple
enought to understand and implement.  Presumably the glibc wrapper
would hide that detail from everyone.
 
> 
> What are your thoughts on this ? What layout should we finalize on ?
> Perhaps, since sync_file_range() system call has similar arguments, we
> can take hint from the challenges faced on implementing it on various
> architectures, and decide.
> 


