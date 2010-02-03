Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab0BCXwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:52:10 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:36257 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab0BCXwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:52:06 -0500
X-Spam-ASN: 
Date: Thu, 4 Feb 2010 02:51:53 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       Rodolfo Giometti <giometti@enneenne.com>,
       Rodolfo Giometti <giometti@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/5] ntp: add hardpps implementation
Message-ID: <20100204025153.52fe962a@lvk.cs.msu.su>
In-Reply-To: <1265234930.3255.54.camel@work-vm>
References: <cover.1265228858.git.lasaine@lvk.cs.msu.su>
	<c90af235d8e68733f04b5365d1be2380ccb23569.1265228858.git.lasaine@lvk.cs.msu.su>
	<1265234930.3255.54.camel@work-vm>
Organization: LVK
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/3E.2gA4=ClmArRG_r2UzfEQ"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3E.2gA4=ClmArRG_r2UzfEQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thanks for the review!

=D0=92 Wed, 03 Feb 2010 14:08:50 -0800
john stultz <johnstul@us.ibm.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Wed, 2010-02-03 at 23:56 +0300, Alexander Gordeev wrote:
> > This commit adds hardpps() implementation based upon the original
> > one from the NTPv4 reference kernel code. However, it is highly
> > optimized towards very fast syncronization and maximum stickness to
> > PPS signal. The typical error is less then a microsecond.
> > To make it sync faster I had to throw away exponential phase filter
> > so that the full phase offset is corrected immediately. Then I also
> > had to throw away median phase filter because it gives a bigger
> > error itself if used without exponential filter.
> > Maybe we will find an appropriate filtering scheme in the future but
> > it's not necessary if the signal quality is ok.
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
>=20
> Very cool! Bunch of style comments below.
>=20
> One other thing: From the comments in the code, it looks like this may
> have come straight from the reference implementation. You might want
> to provide some extra documentation or comment providing proper
> credit, and clarifying that the code is in fact GPLv2 compatible.=20
>=20
> Also please review Section 12 of Documentation/SubmittingPatches=20

Indeed, this code is a direct descendant of the reference
implementation. However it is mostly rewritten because the original
code was too hard to read. But I thought it is not an issue because the
whole ntp.c seems to have a lot of code from it... Well, I'm not quite
good in license compatibility. :)

Here is the copyright notice from the original code for reference:
/***********************************************************************
 *                                                                     *
 * Copyright (c) David L. Mills 1993-2001                              *
 *                                                                     *
 * Permission to use, copy, modify, and distribute this software and   *
 * its documentation for any purpose and without fee is hereby         *
 * granted, provided that the above copyright notice appears in all    *
 * copies and that both the copyright notice and this permission       *
 * notice appear in supporting documentation, and that the name        *
 * University of Delaware not be used in advertising or publicity      *
 * pertaining to distribution of the software without specific,        *
 * written prior permission. The University of Delaware makes no       *
 * representations about the suitability this software for any         *
 * purpose. It is provided "as is" without express or implied          *
 * warranty.                                                           *
 *                                                                     *
 **********************************************************************/

Maybe adding a comment like the one above second_overflow() is enough?


> [snip]
> > +long pps_tf[3];			/* phase median filter */
> > +s64 pps_freq;			/* scaled frequency offset
> > (ns/s) */ +s64 pps_fcount;			/* frequency
> > accumulator */ +long pps_jitter;		/* nominal jitter
> > (ns) */ +long pps_stabil;		/* nominal stability
> > (scaled ns/s) */ +int pps_valid;			/* signal
> > watchdog counter */ +int pps_shift;			/*
> > nominal interval duration (s) (shift) */ +int
> > pps_shiftmax;		/* max interval duration (s) (shift)
> > */ +int pps_intcnt;			/* interval counter */ +
> > +/*
> > + * PPS signal quality monitors
> > + */
> > +long pps_calcnt;		/* calibration intervals */
> > +long pps_jitcnt;		/* jitter limit exceeded */
> > +long pps_stbcnt;		/* stability limit exceeded */
> > +long pps_errcnt;		/* calibration errors */
> > +
>=20
> Shouldn't all of the above values be made static?

Sure, thanks.

> [snip]
>=20
> >  /*
> > @@ -233,8 +277,6 @@ static enum hrtimer_restart
> > ntp_leap_second(struct hrtimer *timer) */
> >  void second_overflow(void)
> >  {
> > -	s64 delta;
> > -
> >  	/* Bump the maxerror field */
> >  	time_maxerror +=3D MAXFREQ / NSEC_PER_USEC;
> >  	if (time_maxerror > NTP_PHASE_LIMIT) {
> > @@ -248,9 +290,27 @@ void second_overflow(void)
> >  	 */
> >  	tick_length	 =3D tick_length_base;
> >=20
> > -	delta		 =3D shift_right(time_offset, SHIFT_PLL
> > + time_constant);
> > -	time_offset	-=3D delta;
> > -	tick_length	+=3D delta;
> > +#ifdef CONFIG_NTP_PPS
> > +	if (time_status & STA_PPSTIME && time_status &
> > STA_PPSSIGNAL) {
> > +		tick_length	+=3D time_offset;
> > +		time_offset	 =3D 0;
> > +	} else
> > +#endif /* CONFIG_NTP_PPS */
> > +	{
> > +		s64 delta;
> > +		delta		 =3D
> > +			shift_right(time_offset, SHIFT_PLL +
> > time_constant);
> > +		time_offset	-=3D delta;
> > +		tick_length	+=3D delta;
> > +	}
>=20
>=20
> Ugh. Surely there's a better way to do this then using the ifdefs in
> code?=20
>=20
> Maybe something like:
>=20
> #ifdef CONFIG_NTP_PPS
> /* Comment about how pps consumes the whole offset */
> static inline s64 ntp_offset_chunk(s64 offset)
> {
> 	if (time_status & STA_PPSTIME && time_status & STA_PPSSIGNAL)
> 		return offset
> 	else
> 		return shift_right(offset, SHIFT_PLL + time_constant);
> }
> #else
> static inline s64 ntp_offset_chunk(s64 offset)
> {
> 	return shift_right(offset, SHIFT_PLL + time_constant);
> }
> #endif
>=20
> Then in second_overflow():
>=20
> delta		 =3D ntp_offset_chunk(time_offset);
> time_offset	-=3D delta;
> tick_length	+=3D delta;
>=20
> Feel free to use a better name then ntp_offset_chunk(), but this keeps
> the logic from being obfuscated by all the #ifdefs
>
> > +#ifdef	CONFIG_NTP_PPS
> > +	if (pps_valid > 0)
> > +		pps_valid--;
> > +	else
> > +		time_status &=3D ~(STA_PPSSIGNAL | STA_PPSJITTER |
> > +				 STA_PPSWANDER | STA_PPSERROR);
> > +#endif /* CONFIG_NTP_PPS */
>=20
> Similarly, can some sort of pps_dec_valid() inline function be used
> here?

Ok, it is better indeed.

> [snip]
>=20
> > +#ifdef	CONFIG_NTP_PPS
> > +
> > +/* normalize the timestamp so that nsec is in the
> > +   ( -NSEC_PER_SEC / 2, NSEC_PER_SEC / 2 ] interval */
> > +static inline struct timespec pps_normalize_ts(struct timespec ts)
> > +{
> > +	if (ts.tv_nsec > (NSEC_PER_SEC >> 1)) {
> > +		ts.tv_nsec -=3D NSEC_PER_SEC;
> > +		ts.tv_sec++;
> > +	}
> > +
> > +	return ts;
> > +}
>=20
> Hrmm.. So by converting a timespec into a second + [-NSEC_PER_SEC/2,
> NSEC_PER_SEC/2] value, you aren't really using a timespec anymore,
> right? I mean, the timepsec_valid() would fail in many cases, for
> instance.
>=20
> I realize its pretty close, and you *can* use a timespec this way, but
> to me it seems reasonable to introduce a new structure (pps_normtime?)
> so that its clear you shouldn't exchange timespec values and
> pps_normtime values directly?
>=20
> This is sort of a nit, and maybe others disagree, so not the most
> critical issue. But it seems like you're abusing the structure a bit.

Well, I don't mind adding a structure for this. Seems like timespec
is not expected to be used this way.

> [snip]
> > +/* decrease frequency calibration interval length */
> > +static inline void pps_dec_freq_interval(void)
> > +{
> > +	if (--pps_intcnt <=3D -4) {
> > +		pps_intcnt =3D -4;
>=20
> Is -4 a magic value?
>=20
> [snip]
> > +	} else {	/* good sample */
> > +		if (++pps_intcnt >=3D 4) {
> > +			pps_intcnt =3D 4;
>=20
> Again, the magic 4?

Yep :)
The values are from the reference implementation. Frequency calculation
is mostly the same as in the original code because it works good.
I'll add a define for these values.

> [snip]
> > +	pps_stabil +=3D (div_s64(((s64)delta_mod) <<
> > +				(NTP_SCALE_SHIFT - SHIFT_USEC),
> > +				NSEC_PER_USEC) - pps_stabil) >>
> > PPS_FAVG;
>=20
> Hmm. Two 64bit divides in this path? This code would run each second,
> right? It would probably be good to see if this could be optimized a
> little bit more, but I guess its similar to ntp_update_frequency()
> which is called on adjtimex() calls (every 16 seconds at most with
> networked ntp).

Well, this is not quite right. The interval is at least 4 seconds (1
<< PPS_FAVG) and increases if the signal is good. Maximum interval
length is 256 seconds (1 << PPS_FAVGDEF).
I don't see how it can be optimized right now.

> > +void hardpps(const struct timespec *p_ts, s64 nsec)
> > +{
> > +	struct timespec ts_norm, freq_norm;
> > +
> > +	ts_norm =3D pps_normalize_ts(*p_ts);
> > +	freq_norm =3D pps_normalize_ts(ns_to_timespec(nsec));
> > +
> [snip]
> > +
> > +	write_seqlock_irq(&xtime_lock);
>=20
> This is called possibly in irq context, right? So you probably want to
> use write_seqlock_irqsave(), no?

Right, thanks, it's bug. However, I think of moving it to a worqueue.

--=20
  Alexander

--Sig_/3E.2gA4=ClmArRG_r2UzfEQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJLagwZAAoJEElrwznyooJb2WgH/1ylDSRyQ5cE6dLNH6SWu2kL
2//vYPVzo1gA7gZLmyts7QG/xzgbkgGUgpnixpQjevTzdeGqwmIWB8/Uf3pcb8ok
Fu/cfmAjx4tMrbIRdNzf5t5yiEfg8YTImPFW5JPN0it9e1UuqxYP8lt6hkD8a+j6
PnMLQJ8fc8oTQ0yvrLHc0OKFqUFvLX9olyNkYM/4drIcUep4FvRt/2xQqpEqw4fJ
Mk99Rrh3aR4u94A5VDyrZ/SaVUugwTWTSm3OwEAupVzKh24ciZOwlfIJ3aTyWDTe
NbrFgnPpzKfMCe25wTOFfSW0m7qA8b0k5N11wn1n+R2yZGWzVYVsNAnyQTQIsMA=
=jLYS
-----END PGP SIGNATURE-----

--Sig_/3E.2gA4=ClmArRG_r2UzfEQ--
