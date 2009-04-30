Return-Path: <linux-kernel-owner+w=401wt.eu-S1762019AbZD3IaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762019AbZD3IaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761641AbZD3I3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:29:16 -0400
Received: from mail43.e.nsc.no ([193.213.115.43]:40426 "EHLO mail43.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761687AbZD3I3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:29:11 -0400
X-Greylist: delayed 3005 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Apr 2009 04:29:10 EDT
From: Henrik Austad <henrik@austad.us>
Reply-To: henrik@austad.us
To: finarfin@dreamos.org
Subject: Re: SCHED_EDF infos
Date: Thu, 30 Apr 2009 09:39:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <164c92d827cbee86ba2c5621716309e6@localhost>
In-Reply-To: <164c92d827cbee86ba2c5621716309e6@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4669089.Da9ZmYlZZi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200904300939.31754.henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4669089.Da9ZmYlZZi
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 29. April 2009 23.36.13 finarfin@dreamos.org wrote:
> Hi,
> I'm new to this list,

If you're new to Linux, may I suggest kernelnewbies as well? This is not re=
ally the place to ask beginners questions, for that, kn is really the place.

And, if you are going to look at rt-tasks, look at linux-rt:

       http://rt.wiki.kernel.org/index.php/Main_Page

> Actually i'm near to BS degree in computer science, and for thesis my
> Operating System Professor suggested to complete (or begin?) SCHED_EDF for
> linux.=20

Se comment at the very end about EDF vs. other policies.

As a first step, I would have evaluated the benefits and limitations of EDF=
 in a multicore environment.=20
=2D What will be the major restrictions?
=2D What will be the major improvements? (why should the kernel care about =
yet another scheduling policy)
=2D Are there better ways of doing this? (like pfair)
=2D are you going for partitioned, clustered or global edf? (and remember t=
hat they all have good and bad sides).
=2D why is a global approcah the only way of getting an optimal scheduler, =
but a horrible approach from a practical point of view?
=2D and a lot of other issues that will be apparent once you start looking =
at this.

I did some work on this last year, you are more than welcome to look at tha=
t.

       http://folk.ntnu.no/henrikau/sched/rt_sched_pro.pdf

> Now i don't know if i'm able to do that, i'm new to linux-kernel
> development:
> 1. Someone is already working on that? This task is still available?

I'm working on SCHED_PFAIR :-) Which is a multicore, ratebased deadline dri=
ven global scheduling policy where I use the PD^2 rules to solve tie-breaks=
=2E In theory, it can reach 100% utilization on all cores without missing d=
eadlines (but in practice you will only get close to 100% as it is not perf=
ect).

> 2. Now there was something implemented about sched_edf?

No, nothing deadline driven is implemented as of yet.

> 3. Into sched-rt-groups.txt there was something that was not very clear (=
in
> my opinion):=20

If you are going to implement something deadline driven and have some sort =
of deadline guarantees, I'd suggest going for a policy *above* sched_rt and=
 let SCHED_(RR|FIFO) be best effort tasks.

>    The next project will be SCHED_EDF (Earliest Deadline First scheduling)
> to bring
>    full deadline scheduling to the linux kernel. Deadline scheduling the
> above
>    groups and treating end of the period as a deadline will ensure that
> they both
>    get their allocated time.

Are you aware that this is actually very difficult to get right? There are =
a *lot* of other things going on in the kernel, you will have unexpected la=
tencies etc.

>    Implementing SCHED_EDF might take a while to complete. Priority
> Inheritance is
>    the biggest challenge as the current linux PI infrastructure is geared
> towards
>    the limited static priority levels 0-139. With deadline scheduling you
> need to
>    do deadline inheritance (since priority is inversely proportional to t=
he
>    deadline delta (deadline - now).

I'd suggest getting the scheduler running first, then look at those problem=
s later. If you spend all your time trying to learn the scheduler and desig=
n in every little feature you need, you'll never finish in time.

deadline inversion will be a problem, in fact, whatever you chooose to be t=
he 'key' for picking tasks (priority, niceness, deadlines, wind direction, =
                 <whatever>), you can pretty much take that and add a -inve=
rsion after it. :)

>    Priority inheritance is a different task?=20
> 4. In your opinion three months will be sufficient for that task? (yeah
> probably this seems a silly question, but if working on that take me a too
> long time i think i have to find another thesis :D i wish to have my degr=
ee
> before the end of this year) =20

That depends on how much you know about the scheduler. And believe me, it i=
s a *lot* of things to take care of.

> 5. For implement that algorithm the general EDF documentation will be
> sufficient? There are some special requisites?
> 6. if you have any suggestion i'll be glad to receive it :)

The problem with EDF is that it is not multicore aware. Sure, you can imple=
ment a global EDF and have it move to all cores, but then you're basically =
stuck at 50% utilization if you want to have any form of deadline handling.=
 Sure there  are ways of increasing this if you make sure that all the dead=
lines are not a factor of another, that the hyperperiod is sufficiently lar=
ge etc etc.

> I hope that this mail doesn't sound useless.

No silly questions, just silly answers.=20
(well, here *are* silly questions, but they tend to be ignored)

> Thank you,=20
> Ivan

Henrik

--nextPart4669089.Da9ZmYlZZi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn5Va4ACgkQ6k5VT6v45lkJqwCfZT1V6WuLHTLXBIik+SzPXPmE
QOUAoPAYpbol02xDBpLjWqhbSsp1MvYh
=Rpvf
-----END PGP SIGNATURE-----

--nextPart4669089.Da9ZmYlZZi--
