Return-Path: <linux-kernel-owner+w=401wt.eu-S1946647AbXD3TNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946647AbXD3TNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946651AbXD3TNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:13:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:3985 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946647AbXD3TNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:13:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mQ3XNMpok7hNrGoqofR64rOZaP/FxvQKLyTPYF5/l2Jk7C9DEnzam8gLoOOpsyBTilhT2iT6UcGq9uHa6Kw4fQRFAYIGPbTYfRKJp3hRyjGkF2lew0eAELKgMyc4dovU0rAWZhdIw7XpkO8iosSKZJKCDQOLtTQCLHLyza1ryNU=
Message-ID: <f69849430704301213l5283b949y53c48c36087969b5@mail.gmail.com>
Date: Mon, 30 Apr 2007 12:13:07 -0700
From: "kernel coder" <lhrkernelcoder@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: AMD dual core opetron optimization
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I'm doing trying to write some optimized code  for AMD dual core
opetron processor.But things are getting no where.I've installed
Fedora 5 with 2.6 series Linux kernel and 4 series GCC

Following are few lines of code which are consuming close to 100
cycles.Yes this is not the forum for such questions but i think people
on linux kernel and GCC are best to answer such type of questions.I'm
realy getting frustated and helpless ,that's why i've put question on
this forum.

/*******************************************/
/* these variables will be used for RDTSC instrucion */
uint64_t before, overhead, clocks;


/*ReadTsc funtion is given below */
before=ReadTsc();
before=ReadTsc();
before=ReadTsc();

overhead=ReadTsc()-before;

printf(" ReadTSC overerhead is %lu ",overhead);


unsigned int test;
unsigned long buffer [128];
buffer[12]=08;
buffer[13]=00;
buffer[23]=06;

/* starting cycles */

before=ReadTsc();

/**************************Start of Targeted code
******************************/

 test= buffer[12] | buffer[13] | buffer[23] ;

 switch( test )

 {

case  12:
                asm(" jmp proc_1");

case  13:
                 asm("jmp proc_2");
case  14:
                 asm("jmp proc_3");
case  15:
                 asm("jmp proc_4");
default :
             asm("jmp proc_5");

}



asm(" proc_5:");

/**************************End of Targeted code ******************************/
           /*current cycles */
           clocks=ReadTsc() ;

         clocks=clocks - before;
         printf("\n cycles consumed %lu \n",clocks - overhead);

/**********************************/

The overhead varies from generally 360  to 395 cycles .Sometimes it
also reduces close to 270 cycles.

Cycles consumed by the targetd code varies from 20 to 100
cycles.Theoratically i thing cycles consumed should be less than
20.Then why so many cycles  ? and the output vary from 20 to 100
cycles .Sometimes it crosses 100 cycles as well.

Sometimes the cycles consumed by targetted code become far less that
the RDTSC instrucion overhead.

Is there better way to write above code.I even used the prefetch
instruction  before the targeted code to make sure that buffer is in
the L1 cache but no success.

The code for ReadTsc() is as follows.Please also tell me if its
correct way to measure cycles .


/*****************************************/

 typedef long long __int64;

 __int64 ReadTSC() {
   int res[2];                              // store 64 bit result here
   #if defined(__GNUC__) && !defined(__INTEL_COMPILER)
   // Inline assembly in AT&T syntax
   #if defined (_LP64)                      // 64 bit mode
      __asm__ __volatile__  (               // serialize (save rbx)
      "xorl %%eax,%%eax \n push %%rbx \n cpuid \n"
       ::: "%rax", "%rcx", "%rdx");
      __asm__ __volatile__  (               // read TSC, store edx:eax in res
      "rdtsc\n"
       : "=a" (res[0]), "=d" (res[1]) );
      __asm__ __volatile__  (               // serialize again
      "xorl %%eax,%%eax \n cpuid \n pop %%rbx \n"
       ::: "%rax", "%rcx", "%rdx");
   #else                                    // 32 bit mode
      __asm__ __volatile__  (               // serialize (save ebx)
      "xorl %%eax,%%eax \n pushl %%ebx \n cpuid \n"
       ::: "%eax", "%ecx", "%edx");
      __asm__ __volatile__  (               // read TSC, store edx:eax in res
      "rdtsc\n"
       : "=a" (res[0]), "=d" (res[1]) );
      __asm__ __volatile__  (               // serialize again
      "xorl %%eax,%%eax \n cpuid \n popl %%ebx \n"
       ::: "%eax", "%ecx", "%edx");
   #endif
   #else
   // Inline assembly in MASM syntax
      __asm {
         xor eax, eax
         cpuid                              // serialize
         rdtsc                              // read TSC
         mov dword ptr res, eax             // store low dword in res[0]
         mov dword ptr res+4, edx           // store high dword in res[1]
         xor eax, eax
         cpuid                              // serialize again
      };
   #endif   // __GNUC__
   return *(__int64*)res;                   // return result
 }


/*****************************************************************/


thanks,
shahzad
