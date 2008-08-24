Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbYHXEwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbYHXEwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 00:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYHXEwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 00:52:01 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:41666 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYHXEwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 00:52:00 -0400
Message-ID: <51467.166.70.238.43.1219551931.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <alpine.LFD.1.10.0808211415410.3487@nehalem.linux-foundation.org>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
    <48AD5A21.7020801@s5r6.in-berlin.de>
    <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com>
    <200808212337.38626.nickpiggin@yahoo.com.au>
    <48ADD8DE.3010209@goop.org>
    <alpine.LFD.1.10.0808211415410.3487@nehalem.linux-foundation.org>
Date: Sat, 23 Aug 2008 22:25:31 -0600 (MDT)
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  2.6.27-rc4 
     released
From: jmerkey@wolfmountaingroup.com
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       paulmck@linux.vnet.ibm.com, "Peter Zijlstra" <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, "David Howells" <dhowells@redhat.com>
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Results from Analysis of GCC volatile/memory barriers

Use of volatile will produce the results intended in those files which
have shared data elements, but will also result in some cases global data
which is not referenced outside of a file and which has not also been
declared as volatile as being treated as static and optimized
into local variables in some cases.

If volatile is avoided entirely, the compiler appears to make correct
assumptions about whether or not it is in fact global memory references.
My conclusion is that the code generation of gcc appears correct and
in fact does a better job than Microsoft's implementation of shared
data management on SMP systems.

If you use volatile, and use optimization at the same time, the compiler
will take you at your word and potentially optimize global references into
local variables.  This is in fact better than MS cl which will ALWAYS
optimize global data into local if volatile is not used with SMP data within
a single file.

If you choose to use volatile, then you had better use it on every variable
you need shared between processors -- or just leave it out entirely -- and
gcc does appear figure it out code references properly (though some of them
are quite odd).

While this may be counter-intuitive, it makes sense.  When you are using
volatile, you are telling the compiler anything not declared as volatile
witihin a given file is fair game for local optimization if you turn on
optimization at the same time.


Analysis

Code Generation for two atomic_t variables.  One an array and the other
standalone -- macros in kernel includes and their interactions
with the compiler may be the basis of some of these cases.

    atomic_inc(&debuggerActive);
    atomic_inc(&debuggerProcessors[processor]);

    55a0:	f0 ff 05 00 00 00 00 	lock incl 0x0
    55a7:	8d 2c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebp
    55ae:	8d 85 00 00 00 00    	lea    0x0(%ebp),%eax
    55b4:	89 04 24             	mov    %eax,(%esp)
    55b7:	f0 ff 85 00 00 00 00 	lock incl 0x0(%ebp)

Although the emitted asssembly is essentially correct, its odd.  two
identical data types, one emitted as a global fixup and the other as
a relative fixup indirected from the stack frame.  This works since
the fixup (substitute for the 0x0) input by the loader is a negative
offset relative to the entire 32 bit address space i.e. lock incl
[ebp-f800XXXX], but its still an odd way to treat an atomic variable.
I would think these would result in an absolute address fixup record
treated some other way than as data referenced from the stack frame.

Code section with mixed volatile declarations

volatile unsigned long ProcessorHold[MAX_PROCESSORS];
unsigned long ProcessorState[MAX_PROCESSORS];

         case 2: /* nmi */
            if (ProcessorHold[processor])  /* hold processor */
            {
               ProcessorHold[processor] = 0;
	       ProcessorState[processor] = PROCESSOR_SUSPEND;

               /* processor suspend loop */
               atomic_inc(&nmiProcessors[processor]);
	       while ((ProcessorState[processor] != PROCESSOR_RESUME) &&
	              (ProcessorState[processor] != PROCESSOR_SWITCH))
               {
	          if ((ProcessorState[processor] == PROCESSOR_RESUME) ||
	              (ProcessorState[processor] == PROCESSOR_SWITCH))
                     break;

                  touch_nmi_watchdog();
                  cpu_relax();
               }
               atomic_dec(&nmiProcessors[processor]);
    56ec:	83 3c b5 00 00 00 00 	cmpl   $0x0,0x0(,%esi,4)
    56f3:	00
    56f4:	74 1b                	je     5711 <debugger_entry+0x17e>
    56f6:	c7 04 b5 00 00 00 00 	movl   $0x0,0x0(,%esi,4)
    56fd:	00 00 00 00
    5701:	f0 ff 85 00 00 00 00 	lock incl 0x0(%ebp)
    5708:	e8 fc ff ff ff       	call   5709 <debugger_entry+0x176>
    570d:	f3 90                	pause
    570f:	eb f7                	jmp    5708 <debugger_entry+0x175>

    // THIS APPEARS BROKEN - THE COMPILER IS TREATING A GLOBAL ARRAY
    // AS LOCAL DATA
    5711:	89 f1                	mov    %esi,%ecx
    5713:	89 da                	mov    %ebx,%edx
    5715:	b8 02 00 00 00       	mov    $0x2,%eax
    571a:	eb 06                	jmp    5722 <debugger_entry+0x18f>
    571c:	89 f1                	mov    %esi,%ecx
    571e:	89 da                	mov    %ebx,%edx
    5720:	89 f8                	mov    %edi,%eax
    5722:	e8 fc ff ff ff       	call   5723 <debugger_entry+0x190>
    5727:	83 3c b5 00 00 00 00 	cmpl   $0x0,0x0(,%esi,4)
    572e:	00
    572f:	75 c5                	jne    56f6 <debugger_entry+0x163>
    5731:	e8 fc ff ff ff       	call   5732 <debugger_entry+0x19f>
    5736:	e8 fc ff ff ff       	call   5737 <debugger_entry+0x1a4>
    573b:	85 c0                	test   %eax,%eax
    573d:	74 0f                	je     574e <debugger_entry+0x1bb>
    573f:	89 f0                	mov    %esi,%eax
    5741:	c1 e0 07             	shl    $0x7,%eax
    5744:	05 00 00 00 00       	add    $0x0,%eax
    5749:	e8 fc ff ff ff       	call   574a <debugger_entry+0x1b7>
    574e:	c7 04 b5 00 00 00 00 	movl   $0x0,0x0(,%esi,4)
    5755:	00 00 00 00
    5759:	8b 04 24             	mov    (%esp),%eax
    575c:	c7 04 b5 00 00 00 00 	movl   $0x1,0x0(,%esi,4)
    5763:	01 00 00 00
    5767:	f0 ff 08             	lock decl (%eax)



Code section without ANY volatile declarations (CODE GENERATION CORRECT)

unsigned long ProcessorHold[MAX_PROCESSORS];
unsigned long ProcessorState[MAX_PROCESSORS];

         case 2: /* nmi */
            if (ProcessorHold[processor])  /* hold processor */
            {
               ProcessorHold[processor] = 0;
	       ProcessorState[processor] = PROCESSOR_SUSPEND;

               /* processor suspend loop */
               atomic_inc(&nmiProcessors[processor]);
	       while ((ProcessorState[processor] != PROCESSOR_RESUME) &&
	              (ProcessorState[processor] != PROCESSOR_SWITCH))
               {
	          if ((ProcessorState[processor] == PROCESSOR_RESUME) ||
	              (ProcessorState[processor] == PROCESSOR_SWITCH))
                     break;

                  touch_nmi_watchdog();
                  cpu_relax();
               }
               atomic_dec(&nmiProcessors[processor]);

Code output from section without ANY volatile declarations

    56f2:	83 3c bd 00 00 00 00 	cmpl   $0x0,0x0(,%edi,4)
    56f9:	00
    56fa:	74 5f                	je     575b <debugger_entry+0x1c8>
    56fc:	c7 04 bd 00 00 00 00 	movl   $0x0,0x0(,%edi,4)
    5703:	00 00 00 00
    5707:	8d b5 00 00 00 00    	lea    0x0(%ebp),%esi
    570d:	c7 04 bd 00 00 00 00 	movl   $0x2,0x0(,%edi,4)
    5714:	02 00 00 00
    5718:	f0 ff 85 00 00 00 00 	lock incl 0x0(%ebp)
    571f:	eb 11                	jmp    5732 <debugger_entry+0x19f>
    5721:	83 f8 03             	cmp    $0x3,%eax
    5724:	74 1d                	je     5743 <debugger_entry+0x1b0>
    5726:	83 f8 07             	cmp    $0x7,%eax
    5729:	74 18                	je     5743 <debugger_entry+0x1b0>
    572b:	e8 fc ff ff ff       	call   572c <debugger_entry+0x199>
    5730:	f3 90                	pause
    5732:	8b 04 bd 00 00 00 00 	mov    0x0(,%edi,4),%eax
    5739:	83 f8 03             	cmp    $0x3,%eax
    573c:	74 05                	je     5743 <debugger_entry+0x1b0>
    573e:	83 f8 07             	cmp    $0x7,%eax
    5741:	75 de                	jne    5721 <debugger_entry+0x18e>
    5743:	f0 ff 0e             	lock decl (%esi)
    5746:	83 3c bd 00 00 00 00 	cmpl   $0x7,0x0(,%edi,4)



Code from section with volatile declarations (CODE GENERATION CORRECT)

volatile unsigned long ProcessorHold[MAX_PROCESSORS];
volatile unsigned long ProcessorState[MAX_PROCESSORS];

         case 2: /* nmi */
            if (ProcessorHold[processor])  /* hold processor */
            {
               ProcessorHold[processor] = 0;
	       ProcessorState[processor] = PROCESSOR_SUSPEND;

               /* processor suspend loop */
               atomic_inc(&nmiProcessors[processor]);
	       while ((ProcessorState[processor] != PROCESSOR_RESUME) &&
	              (ProcessorState[processor] != PROCESSOR_SWITCH))
               {
	          if ((ProcessorState[processor] == PROCESSOR_RESUME) ||
	              (ProcessorState[processor] == PROCESSOR_SWITCH))
                     break;

                  touch_nmi_watchdog();
                  cpu_relax();
               }
               atomic_dec(&nmiProcessors[processor]);


Code Output from section with volatile declarations

    5896:	8b 04 9d 00 00 00 00 	mov    0x0(,%ebx,4),%eax
    589d:	85 c0                	test   %eax,%eax
    589f:	74 73                	je     5914 <debugger_entry+0x1f7>
    58a1:	c7 04 9d 00 00 00 00 	movl   $0x0,0x0(,%ebx,4)
    58a8:	00 00 00 00
    58ac:	8d bd 00 00 00 00    	lea    0x0(%ebp),%edi
    58b2:	c7 04 9d 00 00 00 00 	movl   $0x2,0x0(,%ebx,4)
    58b9:	02 00 00 00
    58bd:	f0 ff 85 00 00 00 00 	lock incl 0x0(%ebp)
    58c4:	eb 1f                	jmp    58e5 <debugger_entry+0x1c8>
    58c6:	8b 04 9d 00 00 00 00 	mov    0x0(,%ebx,4),%eax
    58cd:	83 f8 03             	cmp    $0x3,%eax
    58d0:	74 2b                	je     58fd <debugger_entry+0x1e0>
    58d2:	8b 04 9d 00 00 00 00 	mov    0x0(,%ebx,4),%eax
    58d9:	83 f8 07             	cmp    $0x7,%eax
    58dc:	74 1f                	je     58fd <debugger_entry+0x1e0>
    58de:	e8 fc ff ff ff       	call   58df <debugger_entry+0x1c2>
    58e3:	f3 90                	pause
    58e5:	8b 04 9d 00 00 00 00 	mov    0x0(,%ebx,4),%eax
    58ec:	83 f8 03             	cmp    $0x3,%eax
    58ef:	74 0c                	je     58fd <debugger_entry+0x1e0>
    58f1:	8b 04 9d 00 00 00 00 	mov    0x0(,%ebx,4),%eax
    58f8:	83 f8 07             	cmp    $0x7,%eax
    58fb:	75 c9                	jne    58c6 <debugger_entry+0x1a9>
    58fd:	f0 ff 0f             	lock decl (%edi)
    5900:	8b 04 9d 00 00 00 00 	mov    0x0(,%ebx,4),%eax



Code from sections without volatile declaration using wmb()/rmb()
                                     (CODE GENERATION CORRECT)

   for (i=0; i < MAX_PROCESSORS; i++)
   {
      if (ProcessorState[i] != PROCESSOR_HOLD)
      {
         wmb();
         ProcessorState[i] = PROCESSOR_RESUME;
      }
   }

unsigned long ProcessorHold[MAX_PROCESSORS];
unsigned long ProcessorState[MAX_PROCESSORS];

         case 2: /* nmi */
            if (ProcessorHold[processor])  /* hold processor */
            {
               ProcessorHold[processor] = 0;
	       ProcessorState[processor] = PROCESSOR_SUSPEND;

               /* processor suspend loop */
               atomic_inc(&nmiProcessors[processor]);
	       while ((ProcessorState[processor] != PROCESSOR_RESUME) &&
	              (ProcessorState[processor] != PROCESSOR_SWITCH))
               {
                  rmb();
	          if ((ProcessorState[processor] == PROCESSOR_RESUME) ||
	              (ProcessorState[processor] == PROCESSOR_SWITCH))
                     break;

                  touch_nmi_watchdog();
                  cpu_relax();
               }
               atomic_dec(&nmiProcessors[processor]);

Code output from sections without volatile declaration using wmb()/rmb()

    56fa:	83 3c b5 00 00 00 00 	cmpl   $0x0,0x0(,%esi,4)
    5701:	00
    5702:	74 6b                	je     576f <debugger_entry+0x1d7>
    5704:	c7 04 b5 00 00 00 00 	movl   $0x0,0x0(,%esi,4)
    570b:	00 00 00 00
    570f:	8d bd 00 00 00 00    	lea    0x0(%ebp),%edi
    5715:	c7 04 b5 00 00 00 00 	movl   $0x2,0x0(,%esi,4)
    571c:	02 00 00 00
    5720:	f0 ff 85 00 00 00 00 	lock incl 0x0(%ebp)
    5727:	eb 1d                	jmp    5746 <debugger_entry+0x1ae>
    5729:	f0 83 04 24 00       	lock addl $0x0,(%esp)
    572e:	8b 04 b5 00 00 00 00 	mov    0x0(,%esi,4),%eax
    5735:	83 f8 03             	cmp    $0x3,%eax
    5738:	74 1d                	je     5757 <debugger_entry+0x1bf>
    573a:	83 f8 07             	cmp    $0x7,%eax
    573d:	74 18                	je     5757 <debugger_entry+0x1bf>
    573f:	e8 fc ff ff ff       	call   5740 <debugger_entry+0x1a8>
    5744:	f3 90                	pause
    5746:	8b 04 b5 00 00 00 00 	mov    0x0(,%esi,4),%eax
    574d:	83 f8 03             	cmp    $0x3,%eax
    5750:	74 05                	je     5757 <debugger_entry+0x1bf>
    5752:	83 f8 07             	cmp    $0x7,%eax
    5755:	75 d2                	jne    5729 <debugger_entry+0x191>
    5757:	f0 ff 0f             	lock decl (%edi)
    575a:	83 3c b5 00 00 00 00 	cmpl   $0x7,0x0(,%esi,4)
    5761:	07
    5762:	75 21                	jne    5785 <debugger_entry+0x1ed>
    5764:	89 f1                	mov    %esi,%ecx

000001e1 <FreeProcessorsExclSelf>:
     1e1:	31 c0                	xor    %eax,%eax
     1e3:	83 3c 85 00 00 00 00 	cmpl   $0x8,0x0(,%eax,4)
     1ea:	08
     1eb:	74 10                	je     1fd <FreeProcessorsExclSelf+0x1c>
     1ed:	f0 83 04 24 00       	lock addl $0x0,(%esp)
     1f2:	c7 04 85 00 00 00 00 	movl   $0x3,0x0(,%eax,4)
     1f9:	03 00 00 00
     1fd:	40                   	inc    %eax
     1fe:	83 f8 08             	cmp    $0x8,%eax
     201:	75 e0                	jne    1e3 <FreeProcessorsExclSelf+0x2>
     203:	c3                   	ret



Code from sections without volatile declaration using barrier()
                                       (CODE GENERATION CORRECT)

   for (i=0; i < MAX_PROCESSORS; i++)
   {
      if (ProcessorState[i] != PROCESSOR_HOLD)
      {
         barrier();
         ProcessorState[i] = PROCESSOR_RESUME;
      }
   }

unsigned long ProcessorHold[MAX_PROCESSORS];
unsigned long ProcessorState[MAX_PROCESSORS];

         case 2: /* nmi */
            if (ProcessorHold[processor])  /* hold processor */
            {
               ProcessorHold[processor] = 0;
	       ProcessorState[processor] = PROCESSOR_SUSPEND;

               /* processor suspend loop */
               atomic_inc(&nmiProcessors[processor]);
	       while ((ProcessorState[processor] != PROCESSOR_RESUME) &&
	              (ProcessorState[processor] != PROCESSOR_SWITCH))
               {
                  barrier();
	          if ((ProcessorState[processor] == PROCESSOR_RESUME) ||
	              (ProcessorState[processor] == PROCESSOR_SWITCH))
                     break;

                  touch_nmi_watchdog();
                  cpu_relax();
               }
               atomic_dec(&nmiProcessors[processor]);

Code output from sections without volatile declaration using barrier()

    56f5:	83 3c b5 00 00 00 00 	cmpl   $0x0,0x0(,%esi,4)
    56fc:	00
    56fd:	74 66                	je     5765 <debugger_entry+0x1d2>
    56ff:	c7 04 b5 00 00 00 00 	movl   $0x0,0x0(,%esi,4)
    5706:	00 00 00 00
    570a:	8d bd 00 00 00 00    	lea    0x0(%ebp),%edi
    5710:	c7 04 b5 00 00 00 00 	movl   $0x2,0x0(,%esi,4)
    5717:	02 00 00 00
    571b:	f0 ff 85 00 00 00 00 	lock incl 0x0(%ebp)
    5722:	eb 18                	jmp    573c <debugger_entry+0x1a9>
    5724:	8b 04 b5 00 00 00 00 	mov    0x0(,%esi,4),%eax
    572b:	83 f8 03             	cmp    $0x3,%eax
    572e:	74 1d                	je     574d <debugger_entry+0x1ba>
    5730:	83 f8 07             	cmp    $0x7,%eax
    5733:	74 18                	je     574d <debugger_entry+0x1ba>
    5735:	e8 fc ff ff ff       	call   5736 <debugger_entry+0x1a3>
    573a:	f3 90                	pause
    573c:	8b 04 b5 00 00 00 00 	mov    0x0(,%esi,4),%eax
    5743:	83 f8 03             	cmp    $0x3,%eax
    5746:	74 05                	je     574d <debugger_entry+0x1ba>
    5748:	83 f8 07             	cmp    $0x7,%eax
    574b:	75 d7                	jne    5724 <debugger_entry+0x191>
    574d:	f0 ff 0f             	lock decl (%edi)
    5750:	83 3c b5 00 00 00 00 	cmpl   $0x7,0x0(,%esi,4)
    5757:	07

000001e1 <FreeProcessorsExclSelf>:
     1e1:	31 c0                	xor    %eax,%eax
     1e3:	83 3c 85 00 00 00 00 	cmpl   $0x8,0x0(,%eax,4)
     1ea:	08
     1eb:	74 0b                	je     1f8 <FreeProcessorsExclSelf+0x17>
     1ed:	c7 04 85 00 00 00 00 	movl   $0x3,0x0(,%eax,4)
     1f4:	03 00 00 00
     1f8:	40                   	inc    %eax
     1f9:	83 f8 08             	cmp    $0x8,%eax
     1fc:	75 e5                	jne    1e3 <FreeProcessorsExclSelf+0x2>
     1fe:	c3                   	ret


Jeff

