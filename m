Return-Path: <linux-kernel-owner+w=401wt.eu-S934625AbZGQNfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625AbZGQNfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934600AbZGQNfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:35:14 -0400
Received: from ms01.sssup.it ([193.205.80.99]:44213 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934558AbZGQNfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:35:12 -0400
Message-ID: <4A607E0E.5080302@sssup.it>
Date: Fri, 17 Jul 2009 15:35:10 +0200
From: Giuseppe Lipari <giuseppe.lipari@sssup.it>
Reply-To: giuseppe.lipari@sssup.it
Organization: Scuola Superiore Sant'Anna
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Chris Friesen <cfriesen@nortel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
References: <200907102350.47124.henrik@austad.us>	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>	 <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
In-Reply-To: <1247568455.9086.115.camel@Palantir>
Content-Type: multipart/mixed;
 boundary="------------030501060109050800010904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030501060109050800010904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear all,

a few consideration on the BWI scheme, that was mentioned by 
Peter and by Raistlin a few messages ago. I do not know very 
well the PEP scheme, from the discussion until now the basic 
idea looks pretty similar to our protocol. The BWI is described 
in this paper:

[1] http://feanor.sssup.it/~lipari/papers/rtss2001-bwi.ps.gz

(I just removed the password, feel free to download it, I hope IEEE
lawyers will not chase me!).

In essence, when a task is blocked on a lock, its budget may be
consumed by the task holding the lock. A task can be assigned one or
more pairs (budget,deadline), one is its original one, the others are
"inherited" when holding a lock on which other tasks are blocked.

This scheme has advantages and disadvantages.  The advantages are:

1) Isolation. It is easy to see that the budget of a task can be
stolen only by tasks that share common locks, directly or
indirectly. For the sake simplicity, consider only non nested
locks. If two tasks A and B do not share any lock, then they cannot
influence each other. (In the paper, this property is generalized to
nested locks).  This property is useful if we want to isolate the
behavior of one (group of) task(s) from the others. For example, a
"hard real-time" task (group) must be isolated from soft real-time
tasks.  Under EDF other classical protocols (like PI, SRP) do not have
the same property, because letting a task use a critical section for
longer than expected can jeopardize the schedulability of the any
other tasks.


2) Simpler admission test. With other schemes (PI, SRP), it is
necessary to compute blocking times for all tasks, which depend on the
length of the critical sections.  The blocking times are then used in
the admission test formula. However, if one blocking time is wrongly
calculated, at run-time any task can miss its deadline. With BWI,
instead, the admission test is the simpler \sum U_i \leq 1, and
doesnot depend on the length of the critical section.

3) Under the assumption that tasks do not block inside a critical
section, BWI can be implemented in a fairly simple way.

4) It is indeed possible (under certain conditions) to verify the
schedulability of a hard real-time task H by knowing the length of all
critical sections of all tasks that share some lock with H. The very
complex procedure is explained in the paper.

However, BWI has some disadvantages

1) It is only for single processors.

2) From a schedulability point of view, if we want to guarantee that
every task always respects its deadline, when computing its budget we
must calculate the "interference" of other tasks. Since, we have to do
this for every "hard" task, we may end up counting the same critical
section several times, thus wasting some bandwidth.  This is better
explained in the paper (section 6.4.1).

3) If a task is allowed to block in the middle of a critical section
(for example, due to a page fault), the implementation becomes much
more complex.

Concerning point 1, as Raistlin pointed out (see its e-mails), he is
working on extending BWI to multiprocessors, also from a theoretical
point of view. It is possible that the result will be similar to the
one obtained by the Dougleas Niehaus with PEP. We hope he will be able
to add some "theoretical spice"!

Concerning point 2, this cannot be avoided. We believe that BWI is
useful for open systems (where tasks are created/killed dynamically)
and for soft real-time systems. However, under certain conditions, it
allows to schedule and analyse hard real-time tasks, even when mixed
with soft real-time tasks.

Concerning point 3, this is the most difficult point. In fact,
achieving an efficient implementation in this case seems very
unlikely. However, we believe that blocking inside a critical section
it is probably a rare event, and then maybe it is possible to afford
some extra overhead in such unfortunate cases.

I hope I clarified some obscure issues with BWI! 

Regards,

Giuseppe Lipari



--------------030501060109050800010904
Content-Type: text/x-vcard; charset=utf-8;
 name="giuseppe_lipari.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="giuseppe_lipari.vcf"

begin:vcard
fn:Giuseppe Lipari
n:Lipari;Giuseppe
email;internet:giuseppe.lipari@sssup.it
tel;work:+39 050882030
tel;fax:+39 050882003
tel;cell:+39 3480718908
version:2.1
end:vcard


--------------030501060109050800010904--
