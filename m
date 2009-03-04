Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZCDQBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZCDQBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 11:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZCDQBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 11:01:45 -0500
Received: from mx1.emlix.com ([193.175.82.87]:37340 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbZCDQBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 11:01:45 -0500
Date: Wed, 04 Mar 2009 17:01:09 +0100
From: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
Organization: emlix GmbH
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, x86@kernel.org,
       Bill Metzenthen <billm@melbpc.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, math-emu: fix init_fpu for task != current
References: <E1Le9vp-00020J-AA@mailer.emlix.com> <20090302195230.GA12252@elte.hu>
In-Reply-To: <20090302195230.GA12252@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Message-Id: <E1LetWv-0002Kq-Sq@mailer.emlix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2009 08:52 PM, Ingo Molnar wrote:
> * Daniel Glöckner <dg@emlix.com> wrote:
[..]
>> This patch creates a new function finit_task that takes a task_struct
>> parameter. finit becomes a wrapper that simply calls finit_task with
>> current. On the plus side this avoids many calls to get_current which
>> would each resolve to an inline assembler mov instruction.
[..]
>> --- a/arch/x86/kernel/i387.c
>> +++ b/arch/x86/kernel/i387.c
>> @@ -136,7 +136,7 @@ int init_fpu(struct task_struct *tsk)
>>  #ifdef CONFIG_X86_32
>>  	if (!HAVE_HWFP) {
>>  		memset(tsk->thread.xstate, 0, xstate_size);
>> -		finit();
>> +		finit_task(tsk);
>>  		set_stopped_child_used_math(tsk);
>>  		return 0;
>>  	}
[..]
> 
> ok, the fix looks good - but we sure want to define this 
> function in the "# CONFIG_MATH_EMU is not set" case too, agreed?

To avoid linker errors if the compiler emits the call although !HAVE_HWFP
is always false? Sounds plausible. I also removed finit from i387.h as the
only other external call site, reg_ld_str.c, gets its prototype from
fpu_proto.h.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/x86/include/asm/i387.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 10f349b..71c9e51 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -172,8 +172,13 @@ static inline void __save_init_fpu(struct task_struct *tsk)

 #else  /* CONFIG_X86_32 */

+#ifdef CONFIG_MATH_EMULATION
 extern void finit_task(struct task_struct *tsk);
-extern void finit(void);
+#else
+static inline void finit_task(struct task_struct *tsk)
+{
+}
+#endif

 static inline void tolerant_fwait(void)
 {
--
1.5.6

-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Geschäftsführung: Dr. Uwe Kracke, Dr. Cord Seele, Ust-IdNr.: DE 205 198 055
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160

emlix - your embedded linux partner
