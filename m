Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbZFYSQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbZFYSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZFYSQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:16:50 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:13605 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZFYSQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HK8Whatpc4YV5WAvvIuZIEt0PsftYUg4xR+KSykJCIh2E70jlrr7v30o1KsCll82pa
         hq1caQKJijtvQji8Sk9NlofwYaN9ueFPHbMMMhGHu+bZfQkfbPQ8pWnQA0jJetgFKiy/
         ijrn9jGljaVLaahNZn7nmAvE5/K86ofFvwPsc=
MIME-Version: 1.0
In-Reply-To: <m17hz0i449.fsf@fess.ebiederm.org>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com> 
	<m17hz0i449.fsf@fess.ebiederm.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 25 Jun 2009 14:16:32 -0400
Message-ID: <8bd0f97a0906251116k20807de9k502fb3927e7b88a1@mail.gmail.com>
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not 
	mounted
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 14:02, Eric W. Biederman wrote:
> Denys Vlasenko <vda.linux@googlemail.com> writes:
>> In some circumstances running process needs to re-execute
>> its image.
>>
>> Among other useful cases, it is _crucial_ for NOMMU arches.
>>
>> They need it to perform daemonization. Classic sequence
>> of "fork, parent dies, child continues" can't be used
>> due to lack of fork on NOMMU, and instead we have to do
>> "vfork, child re-exec itself (with a flag to not daemonize)
>> and therefore unblocks parent, parent dies".
>
> Why?
>
> I would expect a simple assembly wrapper around clone would work.
> I.e.  Create a new process but share the MM and reuse the same
> stack. When clone returns if we are the parent exit, otherwise
> continue on with life.

this has already been implemented in uClibc with the hints from Jamie
Lokier, but this was done only recently.  before that, the only way to
daemonize was to vfork+re-exec.

>> Another crucial use case on NOMMU is POSIX shell support.
>> Imagine a shell command of the form "func1 | func2 | func3".
>> This can be implemented on NOMMU by vforking thrice,
>> re-executing the shell in every child in the form
>> "<shell> -c 'body of funcN'", and letting parent wait and collect
>> exitcodes and such. As far as I can see, it's the only way
>> to implement it correctly on NOMMU.
>>
>> The program may re-execute itself by name if it knows the name,
>> but we generally may be unsure about it. Binary may be renamed,
>> or even deleted while it is being run.
>
> It really sounds like you want to implement fork for NOMMU.
> If you have a base address register which everything is relative
> to I can't imagine it would be too hard.  Heck you might even be
> able to do it in user space.

that isnt really feasible.
-mike
