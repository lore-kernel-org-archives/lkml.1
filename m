Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYAWOx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYAWOx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYAWOxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:53:49 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:35390 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbYAWOxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:53:47 -0500
Date: Wed, 23 Jan 2008 15:53:40 +0100
From: Luotao Fu <l.fu@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>,
       Wolfgang Grandegger <wg@grandegger.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc
Message-ID: <20080123145340.GE6200@pengutronix.de>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	Wolfgang Grandegger <wg@grandegger.com>,
	LKML <linux-kernel@vger.kernel.org>,
	RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1200544050.318.18.camel@localhost.localdomain> <478F2A46.5070506@grandegger.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oPmsXEqKQNHCSXW7"
Content-Disposition: inline
In-Reply-To: <478F2A46.5070506@grandegger.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche
	Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 13:33:52 up 2 days,  4:25,  1 user,  load average: 0.46, 0.31,
	0.28
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 10.1.0.69
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oPmsXEqKQNHCSXW7
Content-Type: multipart/mixed; boundary="EXKGNeO8l0xGFBjy"
Content-Disposition: inline


--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

On Thu, Jan 17, 2008 at 11:13:26AM +0100, Wolfgang Grandegger wrote:
> It builds and runs fine on my Icecube-MPC5200 board, now also with the
> latency tracer enabled. That's great. Still, "cyclictest -n -p80 -i1000"
> reports latencies up to 400 us and therefore I tried to trigger and save
> a high latency trace using:
>=20
>   # ./cyclictest -n -p80 -i1000 -b400
>   1.21 0.33 0.11 4/42 1048
>=20
>   T: 0 (  914) P:80 I:1000 C:  38726 Min:     61 Act:  107 Avg:  106
> Max:     377
>   [   91.042169] (      cyclictest-914  |#0): new 39733427 us user-latenc=
y.
>   bash-3.00# cat /proc/latency_trace > trace.log
>=20

I was doing some tests on my mpc5200b Board to reproduce the high latency as
measured by wolfgang.

I ran some tests with=20
while [ 1 ]; do ls /bin;done
as non-rt workload, as in Wolfgangs Scenario.

Now I also got some strange values. My latency lies at round about 100 and =
the
max. latency keep pending normally at about 150us-200us. However the max. v=
alue
will occasionally break out to very high values. I got a max. about 850us a=
fter
some rounds of measurement, which is definitively too high for the processo=
r. I
made some traces and attached the last "interesting" path to this mail.
trace_600_1.log and trace_600_2.log are both taken with -b600. For comparat=
ion I
also added a "normal" trace taken with -b150. In the traces with abnormal l=
ong
latency there're a big "hole" between the last call, which is
clockevents_program_event() in both long traces and the actual schedule()
call. The holes are both about 600 us long, which is the main part of the
latency actually.

Two important things I also noted during my tests:=20
1. I got the unusual latencies on a system booted with nfsrootfs. I ran the=
 same
test scenario on system booted from flash and got no extraordinory results.
After serveral hours test my max. latency lies at round about 200us. =20
2. Even on a nfsrootfs system I could not get the high latencies if I run
hackbench as non-rt workload.

Hence I suppose the unusual results are caused by network/Filesystemaccess.
However I have no idea what could be the reason for the "hole"s in the trac=
e.
Looks almost like the cpu is doing nothing. As I don't have a trace on other
architecture at hand at the moment. I can't say for 100 procent if the trac=
er is
"missing" anything.

Any comments, ideas?

cheers
Luotao Fu
--=20
   Dipl.-Ing. Luotao Fu | Phone: +49-5121-206917-3
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de


--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trace_600_1.log"

cyclicte-16669 0D..2 2203085us+: __schedule+0x1f4/0x40c <IRQ-131-151> (150 180)
cyclicte-16669 0D..1 2203115us+: enqueue_hrtimer+0x48/0x194 (  394 1ca956ec c3a11e98)
cyclicte-16669 0D..2 2203129us+: deactivate_task+0x58/0x9c <cyclicte-16669> (180 5)
 IRQ-131-151   0D..2 2203135us+: __schedule+0x1f4/0x40c <cyclicte-16669> (180 150)
 IRQ-131-151   0D..3 2203160us+: task_setprio+0xc0/0x258 <cyclicte-16668> (0 150)
 IRQ-131-151   0D..3 2203164us+: task_setprio+0x13c/0x258 (    0     0     0)
 IRQ-131-151   0D.h1 2203173us+: hrtimer_interrupt+0xa8/0x2d0 (  394 1c9cb6c7     0)
 IRQ-131-151   0D.h2 2203176us+: hrtimer_interrupt+0x128/0x2d0 (  394 1c9c3800 c02d6788)
 IRQ-131-151   0D.h2 2203199us+: activate_task+0x58/0x9c <softirq--5> (150 4)
 IRQ-131-151   0D.h2 2203217us+: activate_task+0x58/0x9c <softirq--12> (150 5)
 IRQ-131-151   0D.h2 2203224us+: enqueue_hrtimer+0x48/0x194 (  394 1d34ce80 c02d6788)
 IRQ-131-151   0D.h1 2203231us+: clockevents_program_event+0x7c/0x1d0 (  394 1ca956ec bc1d7)
 IRQ-131-151   0D..2 2203250us+: deactivate_task+0x58/0x9c <IRQ-131-151> (150 6)
cyclicte-16668 0D..2 2203259us+: __schedule+0x1f4/0x40c <IRQ-131-151> (150 150)
cyclicte-16668 0D..2 2203272us+: activate_task+0x58/0x9c <IRQ-131-151> (150 5)
cyclicte-16668 0D..2 2203282us+: task_setprio+0x184/0x258 <cyclicte-16668> (150 0)
cyclicte-16668 0DN.2 2203291us+: task_setprio+0x13c/0x258 (    0     1     0)
softirq--5     0D..2 2203306us+: __schedule+0x1f4/0x40c <cyclicte-16668> (0 150)
softirq--5     0D..2 2203340us+: deactivate_task+0x58/0x9c <softirq--5> (150 6)
softirq--12    0D..2 2203346us+: __schedule+0x1f4/0x40c <softirq--5> (150 150)
softirq--12    0D..2 2203361us+: deactivate_task+0x58/0x9c <softirq--12> (150 5)
 IRQ-131-151   0D..2 2203367us+: __schedule+0x1f4/0x40c <softirq--12> (150 150)
 IRQ-131-151   0D..1 2203401us+: activate_task+0x58/0x9c <softirq--9> (150 4)
 IRQ-131-151   0D..2 2203428us+: deactivate_task+0x58/0x9c <IRQ-131-151> (150 5)
softirq--9     0D..2 2203435us+: __schedule+0x1f4/0x40c <IRQ-131-151> (150 150)
softirq--9     0D..2 2203454us+: deactivate_task+0x58/0x9c <softirq--9> (150 4)
cyclicte-16668 0D..2 2203465us+: __schedule+0x1f4/0x40c <softirq--9> (150 0)
cyclicte-16668 0D.h2 2203491us+: activate_task+0x58/0x9c <IRQ-131-151> (150 3)
cyclicte-16668 0D.h2 2203494us+: __trace_start_sched_wakeup+0x14c/0x184 <IRQ-131-151> (49 -1)
cyclicte-16668 0DNh2 2203500us+: __trace_start_sched_wakeup+0x14c/0x184 <IRQ-131-151> (49 -1)
cyclicte-16668 0DNh2 2203501us+: try_to_wake_up+0x184/0x1a4 <IRQ-131-151> (150 0)
 IRQ-131-151   0D..2 2203519us+: __schedule+0x1f4/0x40c <cyclicte-16668> (0 150)
 IRQ-131-151   0D..3 2203539us+: task_setprio+0xc0/0x258 <cyclicte-16668> (0 150)
 IRQ-131-151   0D..3 2203544us+: task_setprio+0x13c/0x258 (    0     0     0)
 IRQ-131-151   0D..2 2203554us+: deactivate_task+0x58/0x9c <IRQ-131-151> (150 4)
cyclicte-16668 0D..2 2203559us+: __schedule+0x1f4/0x40c <IRQ-131-151> (150 150)
cyclicte-16668 0D..2 2203570us+: activate_task+0x58/0x9c <IRQ-131-151> (150 3)
cyclicte-16668 0D..2 2203577us+: task_setprio+0x184/0x258 <cyclicte-16668> (150 0)
cyclicte-16668 0DN.2 2203583us+: task_setprio+0x13c/0x258 (    0     1     0)
 IRQ-131-151   0D..2 2203594us+: __schedule+0x1f4/0x40c <cyclicte-16668> (0 150)
 IRQ-131-151   0D..1 2203605us+: activate_task+0x58/0x9c <softirq--9> (150 4)
 IRQ-131-151   0D..2 2203631us+: deactivate_task+0x58/0x9c <IRQ-131-151> (150 5)
softirq--9     0D..2 2203636us+: __schedule+0x1f4/0x40c <IRQ-131-151> (150 150)
softirq--9     0D..2 2203654us+: deactivate_task+0x58/0x9c <softirq--9> (150 4)
cyclicte-16668 0D..2 2203663us+: __schedule+0x1f4/0x40c <softirq--9> (150 0)
cyclicte-16668 0D..1 2203711us+: enqueue_hrtimer+0x48/0x194 (  394 1d3d76bb c3a15ea8)
cyclicte-16668 0D..2 2203726us+: deactivate_task+0x58/0x9c <cyclicte-16668> (0 3)
      sh-19600 0D..2 2203742us!: __schedule+0x1f4/0x40c <cyclicte-16668> (0 0)
      sh-19600 0D.h1 2204020us+: hrtimer_interrupt+0xa8/0x2d0 (  394 1ca99383     0)
      sh-19600 0D.h2 2204025us+: hrtimer_interrupt+0x128/0x2d0 (  394 1ca956ec c3a11e98)
      sh-19600 0D.h3 2204039us+: activate_task+0x58/0x9c <cyclicte-16669> (180 2)
      sh-19600 0D.h3 2204044us+: __trace_start_sched_wakeup+0x14c/0x184 <cyclicte-16669> (19 -1)
      sh-19600 0DNh3 2204050us+: __trace_start_sched_wakeup+0x14c/0x184 <cyclicte-16669> (19 -1)
      sh-19600 0DNh3 2204051us+: try_to_wake_up+0x184/0x1a4 <cyclicte-16669> (180 0)
      sh-19600 0DNh1 2204058us!: clockevents_program_event+0x7c/0x1d0 (  394 1d34ce80 8a9639)
cyclicte-16669 0D..2 2204680us : __schedule+0x1f4/0x40c <sh-19600> (0 180)


--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trace_600_2.log"

cyclicte-1193  0D..2 2211546us+: __schedule+0x1f4/0x40c <softirq--6> (150 180)
cyclicte-1193  0D..1 2211575us+: enqueue_hrtimer+0x48/0x194 ( 1846 4569198 c3a33e98)
cyclicte-1193  0D..1 2211583us+: clockevents_program_event+0x7c/0x1d0 ( 1846 4569198 dbc5e)
cyclicte-1193  0D..2 2211597us+: deactivate_task+0x58/0x9c <cyclicte-1193> (180 4)
softirq--6     0D..2 2211603us+: __schedule+0x1f4/0x40c <cyclicte-1193> (180 150)
softirq--6     0D..2 2211625us+: deactivate_task+0x58/0x9c <softirq--6> (150 3)
      sh-1902  0D..2 2211637us+: __schedule+0x1f4/0x40c <softirq--6> (150 0)
      sh-1902  0D..2 2211689us+: deactivate_task+0x58/0x9c <sh-1902> (0 2)
      sh-449   0D..2 2211704us+: __schedule+0x1f4/0x40c <sh-1902> (0 0)
      sh-449   0D.h2 2211762us+: activate_task+0x58/0x9c <IRQ-192-149> (150 1)
      sh-449   0D.h2 2211767us+: __trace_start_sched_wakeup+0x14c/0x184 <IRQ-192-149> (49 -1)
      sh-449   0DNh2 2211772us+: __trace_start_sched_wakeup+0x14c/0x184 <IRQ-192-149> (49 -1)
      sh-449   0DNh2 2211773us+: try_to_wake_up+0x184/0x1a4 <IRQ-192-149> (150 0)
 IRQ-192-149   0D..2 2211792us+: __schedule+0x1f4/0x40c <sh-449> (0 150)
 IRQ-192-149   0D..1 2211821us+: activate_task+0x58/0x9c <softirq--7> (150 2)
 IRQ-192-149   0D..2 2211839us+: deactivate_task+0x58/0x9c <IRQ-192-149> (150 3)
softirq--7     0D..2 2211846us!: __schedule+0x1f4/0x40c <IRQ-192-149> (150 150)
softirq--7     0D..1 2211957us+: activate_task+0x58/0x9c <sh-1902> (0 2)
softirq--7     0D.h2 2212039us+: activate_task+0x58/0x9c <IRQ-193-150> (150 3)
softirq--7     0D..2 2212072us+: deactivate_task+0x58/0x9c <softirq--7> (150 4)
 IRQ-193-150   0D..2 2212083us+: __schedule+0x1f4/0x40c <softirq--7> (150 150)
 IRQ-193-150   0D..1 2212098us+: activate_task+0x58/0x9c <softirq--6> (150 3)
 IRQ-193-150   0D..2 2212111us+: deactivate_task+0x58/0x9c <IRQ-193-150> (150 4)
softirq--6     0D..2 2212118us+: __schedule+0x1f4/0x40c <IRQ-193-150> (150 150)
softirq--6     0D..2 2212139us+: deactivate_task+0x58/0x9c <softirq--6> (150 3)
      sh-1902  0D..2 2212152us!: __schedule+0x1f4/0x40c <softirq--6> (150 0)
      sh-1902  0D.h1 2212501us+: hrtimer_interrupt+0xa8/0x2d0 ( 1846 456cfc8     0)
      sh-1902  0D.h2 2212507us+: hrtimer_interrupt+0x128/0x2d0 ( 1846 4569198 c3a33e98)
      sh-1902  0D.h3 2212521us+: activate_task+0x58/0x9c <cyclicte-1193> (180 2)
      sh-1902  0D.h3 2212526us+: __trace_start_sched_wakeup+0x14c/0x184 <cyclicte-1193> (19 -1)
      sh-1902  0DNh3 2212533us+: __trace_start_sched_wakeup+0x14c/0x184 <cyclicte-1193> (19 -1)
      sh-1902  0DNh3 2212534us+: try_to_wake_up+0x184/0x1a4 <cyclicte-1193> (180 0)
      sh-1902  0DNh1 2212541us!: clockevents_program_event+0x7c/0x1d0 ( 1846 4820f3a 2a9658)
cyclicte-1193  0D..2 2213164us : __schedule+0x1f4/0x40c <sh-1902> (0 180)

--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trace_150.log"

cyclicte-12651 0D..2 2241836us+: __schedule+0x1f4/0x40c <sh-12822> (0 180)
cyclicte-12651 0D..1 2241863us+: enqueue_hrtimer+0x48/0x194 ( 2038 2ae2bf80 c3b57e98)
cyclicte-12651 0D..1 2241871us+: clockevents_program_event+0x7c/0x1d0 ( 2038 2ae2bf80 d8949)
cyclicte-12651 0D..2 2241886us+: deactivate_task+0x58/0x9c <cyclicte-12651> (180 2)
      sh-12822 0D..2 2241898us!: __schedule+0x1f4/0x40c <cyclicte-12651> (180 0)
      sh-12822 0D..1 2242158us+: activate_task+0x58/0x9c <telnetd-423> (0 1)
      sh-12822 0DN.1 2242172us+: try_to_wake_up+0x184/0x1a4 <telnetd-423> (0 0)
 telnetd-423   0D..2 2242198us+: __schedule+0x1f4/0x40c <sh-12822> (0 0)
 telnetd-423   0D..2 2242253us+: deactivate_task+0x58/0x9c <telnetd-423> (0 2)
      sh-12822 0D..2 2242264us+: __schedule+0x1f4/0x40c <telnetd-423> (0 0)
      sh-12822 0D..2 2242274us+: activate_task+0x58/0x9c <telnetd-423> (0 1)
      sh-12822 0DN.2 2242281us+: try_to_wake_up+0x184/0x1a4 <telnetd-423> (0 0)
 telnetd-423   0D..2 2242293us+: __schedule+0x1f4/0x40c <sh-12822> (0 0)
 telnetd-423   0D..2 2242339us+: deactivate_task+0x58/0x9c <telnetd-423> (0 2)
      sh-12822 0D..2 2242351us!: __schedule+0x1f4/0x40c <telnetd-423> (0 0)
      sh-12822 0D..3 2242490us+: activate_task+0x58/0x9c <telnetd-423> (0 1)
      sh-12822 0DN.3 2242499us+: try_to_wake_up+0x184/0x1a4 <telnetd-423> (0 0)
 telnetd-423   0D..2 2242516us!: __schedule+0x1f4/0x40c <sh-12822> (0 0)
 telnetd-423   0D..2 2242774us+: deactivate_task+0x58/0x9c <telnetd-423> (0 2)
      sh-12822 0D..2 2242796us+: __schedule+0x1f4/0x40c <telnetd-423> (0 0)
      sh-12822 0D.h2 2242819us+: activate_task+0x58/0x9c <IRQ-193-150> (150 1)
      sh-12822 0D.h2 2242824us+: __trace_start_sched_wakeup+0x14c/0x184 <IRQ-193-150> (49 -1)
      sh-12822 0DNh2 2242828us+: __trace_start_sched_wakeup+0x14c/0x184 <IRQ-193-150> (49 -1)
      sh-12822 0DNh2 2242830us+: try_to_wake_up+0x184/0x1a4 <IRQ-193-150> (150 0)
 IRQ-193-150   0D..2 2242846us+: __schedule+0x1f4/0x40c <sh-12822> (0 150)
 IRQ-193-150   0D.h. 2242860us+: hrtimer_interrupt+0xa8/0x2d0 ( 2038 2ae44ab9     0)
 IRQ-193-150   0D.h1 2242863us+: hrtimer_interrupt+0x128/0x2d0 ( 2038 2ae2bf80 c3b57e98)
 IRQ-193-150   0D.h2 2242871us+: activate_task+0x58/0x9c <cyclicte-12651> (180 2)
 IRQ-193-150   0D.h2 2242875us+: __trace_start_sched_wakeup+0x14c/0x184 <cyclicte-12651> (19 -1)
 IRQ-193-150   0DNh2 2242877us : __trace_start_sched_wakeup+0x14c/0x184 <cyclicte-12651> (19 -1)
 IRQ-193-150   0DNh2 2242878us+: try_to_wake_up+0x184/0x1a4 <cyclicte-12651> (180 150)
 IRQ-193-150   0DNh. 2242885us+: clockevents_program_event+0x7c/0x1d0 ( 2038 2aea5400 5a227)
cyclicte-12651 0D..2 2242900us : __schedule+0x1f4/0x40c <IRQ-193-150> (150 180)

--EXKGNeO8l0xGFBjy--

--oPmsXEqKQNHCSXW7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHl1T0iruQY+UyUmERArWjAJ4k9yR3tWKBR5HAYlF1gsY/H402dgCgxpnu
xfyYmsBFR9YHmYyN2JAtTmg=
=VCWX
-----END PGP SIGNATURE-----

--oPmsXEqKQNHCSXW7--
