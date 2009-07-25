Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZGYXYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZGYXYa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 19:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZGYXY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 19:24:29 -0400
Received: from ms01.sssup.it ([193.205.80.99]:47624 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632AbZGYXY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 19:24:28 -0400
Message-ID: <4A6B942A.3050201@sssup.it>
Date: Sun, 26 Jul 2009 01:24:26 +0200
From: Tommaso Cucinotta <cucinotta@sssup.it>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       sen wang <wangsen.linux@gmail.com>, mingo@elte.hu,
       akpm@linux-foundation.org, kernel@kolivas.org, npiggin@suse.de,
       arjan@infradead.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: report a bug about sched_rt
References: <1248441290.6987.52.camel@twins> <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com> <1248442415.6987.56.camel@twins> <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com> <1248443656.6987.61.camel@twins> <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com> <1248446910.6987.111.camel@twins> <20090724154036.GG27755@shareable.org> <1248451279.6987.138.camel@twins> <1248524354.8429.100.camel@Palantir> <20090725225459.GB15260@shareable.org>
In-Reply-To: <20090725225459.GB15260@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jamie Lokier ha scritto:
> Raistlin wrote:
>   
>>>   http://feanor.sssup.it/~faggioli/papers/OSPERT-2009-dlexception.pdf
>>>       
>> Moreover, we are open to any
>> suggestion and contribution about this work, especially from the
>> community!
>>     
>
> The biggest weakness I see is if the application has a bug such as
> overwriting random memory or terminating the thread which is receiving
> timer signals, it can easily break the scheduling policy by accident.
>
> When the scheduling policy is implemented in the kernel, it can only
> be broken by system calls requesting a change of scheduling policy,
> which are relatively unlikely, and if necessary that can be completely
> prevented by security controls.
>   
First, thanks for your comments and interest. The mentioned mechanism 
should be regarded as something that helps in the development of 
programs that need to meet timing requirements. This is not meant at all 
to constitute a "user-level" scheduler, nor to replace a real-time 
scheduler job. Contrarily, its purpose is solely to push towards a 
software design paradigm in which the "awareness" of the existing timing 
constraints, and the "awareness" of the possibility that they might be 
violated (on a GPOS) is coded at the program-level (by means of an 
exception-like paradigm). The mechanism has been designed as a 
complement to the real-time scheduling facilities that the kernel 
provides. As an example, imagine that, by a proper configuration of the 
scheduling policy and parameters, an application may be guaranteed a 
certain budget every period. However, the requested budget cannot be the 
actual worst-case, because it would not be practical to compute it (nor 
feasible, cause it would depend on a lot of external factors such as 
interrupt load etc...) and it would lead to too much under-usage of 
resources. By using this exception-like paradigm, the developer may 
code, into an "exception-handler" segment, the recovery actions needed 
whenever the real-time task is about to violate for example its WCET 
constraints (for example, one could use a "try_wcet()" block with a WCET 
specs which is slightly lower than the budget configured into the 
scheduler, i.e., the difference being the WCET of the exception handling 
code). Then, the real-time scheduler will still enforce the configured 
budget for this application, so, if the recovery logics embedded inside 
the exception-handler takes too much (i.e., its WCET has been 
under-estimated), then the temporal isolation is guaranteed anycase, and 
the application won't impact negatively other applications' real-time 
guarantees provided by the scheduler.
In fact, we're working on a practical case-study where both the 
timing-exception mechanism and one of the real-time schedulers we have 
here at SSSA is used. For example, a potential issue we're thinking 
about is if and how to "synchronize" someway the vision of time of the 
exception-based mechanism and the one of the scheduler, because in prior 
experiences built modifying multimedia applications for taking advantage 
of feedback-based real-time scheduling, this was one of the burden to 
face with, before the application started behaving as "theoretically" 
foreseen.

Hope this clarifies our view. Please, feel free to post further comments.

Regards,

  T.
