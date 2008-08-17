Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbYHQLNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbYHQLNy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 07:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYHQLNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 07:13:46 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:41674 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYHQLNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 07:13:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W+IirZhlpjiGNcFHSGj4fgMHCAoiKH+P20AN/FvZrcg4j36728tUkt/xbUp1qDa9np
         FfREFxLLHLoMOAaRNSOtj6as4Hdkm+LU6bqB+EKw0ZwuiWkdeoYVzpZSqc6zR6UiEB+p
         oFyg1bqOfr41gbhsv4pmoOLZ5AGR3E8Y/kGWU=
Message-ID: <93655eb70808170413w43e62311i713166beb38a4897@mail.gmail.com>
Date: Sun, 17 Aug 2008 16:43:44 +0530
From: "Satish Eerpini" <eerpini@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: patching kdb to Centos kernel : error
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <23408.1218955331@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <93655eb70808162300i4286eac9p9aa34cf23359ff72@mail.gmail.com>
	 <23408.1218955331@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i am patching kdb-v4.4-2.6.18-common-1 and kdb-v4.4-2.6.18-i386-1

and following are the rejects i got , ... and nowhere could i make
sense for the above mentioned errors , ... am i missing on something
over here ?

include/linux/sysctl.h.rej from kdb-v4.4-2.6.18-common-1 ( i could fix
this, or so i think , ... by manually adding the macro definitions to
the header file , .... and i agree i am totally unaware of the
consequences )

***************
*** 150,155 ****
  	KERN_IA64_UNALIGNED=72, /* int: ia64 unaligned userland trap enable */
  	KERN_COMPAT_LOG=73,	/* int: print compat layer  messages */
  	KERN_MAX_LOCK_DEPTH=74,
  };


--- 150,156 ----
  	KERN_IA64_UNALIGNED=72, /* int: ia64 unaligned userland trap enable */
  	KERN_COMPAT_LOG=73,	/* int: print compat layer  messages */
  	KERN_MAX_LOCK_DEPTH=74,
+ 	KERN_KDB=75,		/* int: kdb on/off */
  };


arch/i386/kernel/traps.c.rej from  kdb-v4.4-2.6.18-i386-1 :

***************
*** 786,791 ****
  	printk(" on CPU%d, eip %08lx, registers:\n",
  		smp_processor_id(), regs->eip);
  	show_registers(regs);
  	printk(KERN_EMERG "console shuts up ...\n");
  	console_silent();
  	spin_unlock(&nmi_print_lock);
--- 797,805 ----
  	printk(" on CPU%d, eip %08lx, registers:\n",
  		smp_processor_id(), regs->eip);
  	show_registers(regs);
+ #ifdef	CONFIG_KDB
+ 	kdb(KDB_REASON_NMI, 0, regs);
+ #endif	/* CONFIG_KDB */
  	printk(KERN_EMERG "console shuts up ...\n");
  	console_silent();
  	spin_unlock(&nmi_print_lock);

arch/i386/kernel/vmlinux.lds.S.rej from kdb-v4.4-2.6.18-i386-1 :

***************
*** 134,139 ****
  	*(.con_initcall.init)
    }
    __con_initcall_end = .;
    SECURITY_INIT
    . = ALIGN(4);
    __alt_instructions = .;
--- 134,144 ----
  	*(.con_initcall.init)
    }
    __con_initcall_end = .;
+   __kdb_initcall_start = .;
+   .kdb_initcall.init : AT(ADDR(.kdb_initcall.init) - LOAD_OFFSET) {
+ 	*(.kdb_initcall.init)
+   }
+   __kdb_initcall_end = .;
    SECURITY_INIT
    . = ALIGN(4);
    __alt_instructions = .;


, .... i seem to be using the correct kdb patch but the rejects seem
to be the result of the fact that redhat guys have a lot of custom
patches which are added to get the redhat/CentOS kernel . Also because
i could patch kernel 2.6.18.4 without any problems what so ever .



Thanks
Satish

  On Sun, Aug 17, 2008 at 12:12 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sun, 17 Aug 2008 11:30:41 +0530, Satish Eerpini said:
>> hi everyone , i was trying to patch kdb with CentOS 5.0 kernel
>> (2.6.18-8)
>
> You might want to make sure you're using a 2.6.18-vintage kdb patch, as
> trying to fit a 2.6.26 kdb onto a 2.6.18 kernel is unlikely to bring joy.
>
>> resolve) ,.... but apart from the rejects during the kernel
>> compilation i got the following error which does not seem to have
>> anything to do with the rejects ............
>
> No, the rejects during the patch are almost certainly related to your
> compile errors...
>
>>  the code(in kdb/modules/kdbm_pg.c) which is causing the second error
>> is something like this :
>>
>>              iaddr += offsetof(struct inode, u);
>>
>> what i am not able to understand is that if 'u' is not a correct
>> member of the inode , .. then what did they( whoever wrote this piece
>> code) intend by 'u' ? , .....
>
> Your kdb patch probably includes a patch to include/linux/fs.h that adds a
> member 'u' to a 'struct inode'.  If this generated a reject, then the member 'u'
> won't be in the struct, and your compile dies...
>
>> and for the first error , ... i just checked out the code ....
>> according to the line no shown in the error .....the code is :
>>
>>              kdb_page_flags(page, Checked);
>>
>> and i don't see any function PageChecked ....! so what can the error
>> actually mean ??
>
> kdb_page_flags is probably a macro that does something like:
>
> #define kdb_page_flags(a,b) (..... Page##b)
>
> The 'implicit declaration' is most likely a missing #include someplace,
> which again hints at the rejects from a misapplied patch...
>



-- 
http://satish.playdrupal.com
