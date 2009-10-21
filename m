Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZJUI2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZJUI2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 04:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZJUI2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 04:28:32 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57323 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103AbZJUI2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 04:28:31 -0400
Date: Wed, 21 Oct 2009 10:28:13 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] consider stack access while checking for alternate
 signal stack
Message-ID: <20091021082813.GA8655@Chamillionaire.breakpoint.cc>
References: <20091018191247.GA21844@Chamillionaire.breakpoint.cc>
 <20091019073358.GE17960@elte.hu>
 <20091019080239.GB25783@Chamillionaire.breakpoint.cc>
 <20091019180810.3CB751E@magilla.sf.frob.com>
 <20091019193058.GA29613@Chamillionaire.breakpoint.cc>
 <20091020211116.2B76F81A3@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091020211116.2B76F81A3@magilla.sf.frob.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland McGrath | 2009-10-20 14:11:16 [-0700]:

>> >+#ifdef CONFIG_STACK_GROWSUP
>> >+	return sp >= current->sas_ss_sp &&
>> >+		sp - current->sas_ss_sp < current->sas_ss_size;
>> 
>> CONFIG_STACK_GROWSUP is wrong: If your stack grows up and sp ==
>> sas_ss_sp + size than you are using the last entry in your sig stack
>> which will be not recognized correctly. 
>
>+		sp - current->sas_ss_sp <= current->sas_ss_size;
>
>then?

+		sp - current->sas_ss_sp < current->sas_ss_size;
That (the old code) is correct on POST_* architectures. However we don't
have any.

>> The case where sp == sas_ss_sp
>> is also not detected correctly but this should not happen in real life.
>
>So you say that sp==sas_ss_sp should not be considered "on the sig stack"?
Exactly. Because if you have a PRE_* architecture than you first
increment/decrement the stack and than store the value.
So if sp == sas_ss_sp than your next store on the stack will be just
below the begin of your sig stack.

>> That is the PRE case which is the only relevant since we don't have any
>> POST architectures. The check here produces the same results as my
>> variant so it is okay :)
>> So you prefer the smaller patch with comments around it?
>
>Yes, I think it is far clearer and easier to read than what you posted.
Okay. This would bring us to:

-       return (sp - current->sas_ss_sp < current->sas_ss_size);
+       /* This considers PRE_DEC and PRE_INC architectures */
+       return sp > current->sas_ss_sp &&
+               sp - current->sas_ss_sp <= current->sas_ss_size;

And I throw my table away and put something else into patch's comment?

>
>Thanks,
>Roland

Sebastian
