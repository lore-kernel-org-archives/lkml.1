Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZF3NLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZF3NLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 09:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZF3NLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 09:11:32 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:58702 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbZF3NLc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 09:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ErpYf/HLBqyRcAPecxAz1nFjoS/yA2dL8y6T93G4Gqt8yeu/GmlwPovwM6w0UC00dw
         LKdWerC1Q+XklDUYnmfhU2ys6DIFcpExiTFkLjySErOPwTCUmm8ceezRMxlWAl/0ht4E
         Y007MnXnjUo3HK9gtNlAdTpA7xwlp4b7/UGYg=
MIME-Version: 1.0
In-Reply-To: <20090629083051.232bac68@infradead.org>
References: <817ecb6f0906290816t2537e5des3b78b32c6fd16700@mail.gmail.com>
	 <20090629083051.232bac68@infradead.org>
Date: Tue, 30 Jun 2009 09:11:33 -0400
Message-ID: <817ecb6f0906300611s3b21b85by54e689e073bd2012@mail.gmail.com>
Subject: Re: [PATCH v2] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 11:30 AM, Arjan van de Ven<arjan@infradead.org> wrote:
> On Mon, 29 Jun 2009 11:16:40 -0400
> Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
>
>> This patch is a logical extension of the protection provided by
>> CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
>> module_core and module_init into three logical parts each and setting
>> appropriate page access permissions for each individual section:
>>
>>   1. Code: RO+X
>>   2. RO data: RO+NX
>>   3. RW data: RW+NX
>>
>> In order to achieve proper protection, layout_sections() have been
>> modified to align each of the three parts mentioned above onto page
>> boundary. Next, the corresponding page access permissions are set
>> right before successful exit from load_module(). Further,
>> module_free() have been modified to set module_core or module_init as
>> RW+NX right before calling vfree(). Functionality of this patch is
>> enabled only when CONFIG_DEBUG_RODATA defined at compile time.
>>
>> This is the second revision of the patch: it have been re-written to
>> reduce the number of #ifdefs and to make it architecture-agnostic.
>> Code formatting have been corrected also.
>>
>
> you can still go one step further....
> there is no downside to doing NX at all for modules, except for the 3
> sections now each being page aligned thing. So in principle NX should
> just not be part of any ifdef, only the alignment has any justification
> for being so.
> What you can do in the !CONFIG_OPTION case, is treating the "overlap"
> pages as "most permissive goes"..... if you do that you should have 1
> ifdef in total.
>
> (and one can still argue that making this an option is not even worth
> that, and just always do it unconditional)
>

I can make NX unconditional. However, it will not reduce the number of #ifdefs.
There are two of them in the patch right now: one controls the inclusion of two
extra fields (init_ro_size, core_ro_size) in struct module, and the other one
controls the inclusion of ALL patch code. The *_ro_size fields are used only
for RO, and are not used to set NX. Therefore, this #ifdef will stay even if
NX is unconditional. Since the second #ifdef controls ALL of the patch's code
it will also stay (to control RO part) when NX becomes unconditional.

Given that it will not reduce the number of #ifdefs, do you still think that NX
should be made unconditional?

Thanks.
