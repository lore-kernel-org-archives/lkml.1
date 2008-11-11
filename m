Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYKKPME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYKKPME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 10:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbYKKPLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 10:11:53 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:3848 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbYKKPLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 10:11:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Vssvx8nC+qxXHVn1rbS27pVR09JRF+PVb8X4LRHkVONEPnWV6dY1nzL3bGNXp4dDnd
         T6NVB9nadyTh9I0iYCKDMNMuYwLC65y0v/7nXo+4D7EttFLtWHXM0GWDTZKouRnLD8lQ
         dfLndKa2LhMVbfEtwVYL7WTmafBpZI1IFIQ0Y=
Message-ID: <b647ffbd0811110711n40b23212n6ccfc2a3ab192bcc@mail.gmail.com>
Date: Tue, 11 Nov 2008 16:11:51 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to chanes in stop_machine
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Oleg Nesterov" <oleg@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <19f34abd0811110647y2a00cfbfr2b219a5aa1b3ac9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <20081110120401.GA15518@osiris.boeblingen.de.ibm.com>
	 <200811101547.21325.rjw@sisk.pl> <200811102355.42389.rjw@sisk.pl>
	 <20081111105214.GA15645@elte.hu>
	 <19f34abd0811110647y2a00cfbfr2b219a5aa1b3ac9f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/11 Vegard Nossum <vegard.nossum@gmail.com>:
> On Tue, Nov 11, 2008 at 11:52 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> [ Cc:-ed workqueue/locking/suspend-race-condition experts. ]
>>
>> Seems like the new kernel/stop_machine.c logic has a race for the test
>> sequence above. (Below is the bisected commit again, maybe the race is
>> visible via email review as well.)
>
> I try again.
>
> I think that the test for stop_machine_data in stop_cpu() should not
> have been moved from __stop_machine().

Do you mean the following test?

        if (!active_cpus) {
                if (cpu == first_cpu(cpu_online_map))
                        smdata = &active;
        } else {
                if (cpu_isset(cpu, *active_cpus))
                        smdata = &active;
        }

> Because now cpu_online_map may
> change in-between calls to stop_cpu() (if the callback tries to
> online/offline CPUs), and the end result may be different.

take_cpu_down() may not run earlier than stop_cpu() on all the cpus
have completed the STOPMACHINE_DISABLE_IRQ step, iow. "state ==
STOPMACHINE_RUN". By that moment, 'smdata' has been set up on all
cpus... if this is the case you had in mind.


>
> Maybe?
>
>
> Vegard
>


-- 
Best regards,
Dmitry Adamushko
