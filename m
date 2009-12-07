Return-Path: <linux-kernel-owner+w=401wt.eu-S934820AbZLGMhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934820AbZLGMhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934734AbZLGMhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:37:20 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60899 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934730AbZLGMhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:37:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YvLX9uVXmFwKtL9OdFZ4rjttNZsZbA9dQa/E5xpc/qQw5pDs0a4frnIcg7eG/8oW/p
         rjxOywnNLQhVgSozX6YOMxiQDWEtC8x/c6W+04LR1qd1/pOiHu9C/GqgNEdpHnY1GlKD
         ibZfliF+SF5CzrFfN3PGB07Pn8k5m1nhBKgw4=
Message-ID: <4B1CF701.3070805@gmail.com>
Date: Mon, 07 Dec 2009 13:37:21 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-9.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org
Subject: Re: [PATCH 1/1] X86: use explicit register name for get/put_user
References: <1260091808-8053-1-git-send-email-jslaby@suse.cz> <4B1C01F4.8020304@zytor.com>
In-Reply-To: <4B1C01F4.8020304@zytor.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2009 08:11 PM, H. Peter Anvin wrote:
> On 12/06/2009 01:30 AM, Jiri Slaby wrote:
>>
>> I don't know if this could ever cause any problems, but changing
>> the input to an explicit register ("a") makes it cleaner in my eyes.
>> There is no need of the back reference.
>>
> 
> It can't: the backreference refers to only the information that is in
> the register constraint, not to anything else.

Is this documented somewhere? Or do we rely on an undocumented feature?
I mean it doesn't refer only to the constraint but also to a concrete
register allocation. As far as I understand it (from the gcc 4.4
documentation), if one does
 "insn %0" : "=r" (out) : "0" (in)
the "0" constraint corresponds to the concrete register allocated for
out, not to any register (which is the constraint "r").

In the document they write only about the "same location" occupied by in
and out, nothing is said about size (and hence I think we cannot
mismatch size of operands). And I couldn't find any other
restrictions/documentation about inline assembly, hence the patch,
because nothing assured me this cannot change in the future.

Now I tried different compilers (clang, llvm-gcc) and they choke on that:
$ cat c.c
void x(void)
{
        unsigned long in;
        int out;
        asm("insn %0" : "=r" (out) : "0" (in));
}
$ clang c.c -S -o -
c.c:5:36: error: unsupported inline asm: input with type 'unsigned long'
      matching output with type 'int'
        asm("insn %0" : "=r" (out) : "0" (in));
                              ~~~         ^~
1 diagnostic generated.
$ llvm-gcc c.c -S -o -
c.c: In function 'x':
c.c:5: error: unsupported inline asm: input constraint with a matching
output constraint of incompatible type!

thanks for the review,
-- 
js
