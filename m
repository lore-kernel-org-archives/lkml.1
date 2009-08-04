Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbZHDUxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbZHDUxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbZHDUxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:53:45 -0400
Received: from smtp-out28.alice.it ([85.33.2.28]:3072 "EHLO
	smtp-out28.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697AbZHDUxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:53:43 -0400
Date: Tue, 4 Aug 2009 22:52:47 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
       eric.y.miao@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       openezx-devel@lists.openezx.org,
       Stefan Schmidt <stefan@datenfreihafen.org>
Subject: Re: [PATCH v2] input: PCAP2 based touchscreen driver
Message-Id: <20090804225247.8a0bf6d4.ospite@studenti.unina.it>
In-Reply-To: <20090803172125.2A490526EA5@mailhub.coreip.homeip.net>
References: <1249291800-15316-1-git-send-email-drwyrm@gmail.com>
	<20090803172125.2A490526EA5@mailhub.coreip.homeip.net>
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.16.5; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Aug_2009_22_52_48_+0200_/tzF.SIunqwF18Dn"
X-OriginalArrivalTime: 04 Aug 2009 20:53:10.0679 (UTC) FILETIME=[939A9A70:01CA1545]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Aug_2009_22_52_48_+0200_/tzF.SIunqwF18Dn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Aug 2009 10:21:19 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Hi Daniel,
>

Hi Dmitry, I am handling this review round.

> > Please note that the driver depends on some changes from the for-next b=
ranch
> > in Samuel Ortiz's mfd tree:
> > http://git.kernel.org/?p=3Dlinux/kernel/git/sameo/mfd-2.6.git;a=3Dshort=
log;h=3Dfor-next
> >=20
> > should this be queued by Samuel or the input people will you take care
> > to send this mainline only after Samuel's tree has been merged?
> >=20
>=20
> I don't mind it going through another tree once all the kinks are worked
> out.
>

Fine.

> > +static int pcap_ts_open(struct input_dev *dev)
> > +{
> > +	struct pcap_ts *pcap_ts =3D input_get_drvdata(dev);
> > +	int err;
> > +
> > +	err =3D request_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS),
> > +			pcap_ts_event_touch, 0, "Touch Screen", pcap_ts);
> > +	if (err)
> > +		return err;
>=20
> Normally we try to request IRQ in probe() methods instead of delaying it
> till open. Open() is supposed to kick-start the device, but not allocate
> resoirces.
>

Ok, will do.

I must have misunderstood the description of the .open() method in
linux/input.h:
 * @open: this method is called when the very first user calls
 *	input_open_device(). The driver must prepare the device
 *	to start generating events (start polling thread,
 *	request an IRQ, submit URB, etc.)

Does the second sentence here intends that the preparation must be done
in .probe()?

> > +
> > +	pcap_ts->read_state =3D PCAP_ADC_TS_M_STANDBY;
> > +	schedule_delayed_work(&pcap_ts->work, 0);
> > +
> > +	return 0;
> > +}
> > +
> > +static void pcap_ts_close(struct input_dev *dev)
> > +{
> > +	struct pcap_ts *pcap_ts =3D input_get_drvdata(dev);
> > +
> > +	cancel_delayed_work_sync(&pcap_ts->work);
>=20
> So what happens if the device raises IRQ here?
>

Swapping the line with the free_irq() should be ok?

> > +	free_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS), pcap_ts);
> > +
> > +	pcap_ts->read_state =3D PCAP_ADC_TS_M_NONTS;
> > +	pcap_set_ts_bits(pcap_ts->pcap,
> > +				pcap_ts->read_state << PCAP_ADC_TS_M_SHIFT);
> > +}
> > +
> > +static int __devinit pcap_ts_probe(struct platform_device *pdev)
> > +{
> > +	struct input_dev *input_dev;
> > +	struct pcap_ts *pcap_ts;
> > +	int err =3D -ENOMEM;
> > +
> > +	pcap_ts =3D kzalloc(sizeof(*pcap_ts), GFP_KERNEL);
> > +	if (!pcap_ts)
> > +		return err;
> > +
> > +	pcap_ts->pcap =3D platform_get_drvdata(pdev);
> > +	platform_set_drvdata(pdev, pcap_ts);
>=20
> Ewww... Don't mess with data that does not belong to you. Also I don't
> see where you restore it so after unloading the driver reload with
> probably lead to "inetersting" results.
>

Dmitry can you suggest a better way to make the pcap_ts pointer get to
pcap_ts_remove()? We need it in order to remove the input device.
Or keeping this hack, restoring the original value on remove, can be
acceptable?

We will have to fix this also in all other pcap subdrivers.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Tue__4_Aug_2009_22_52_48_+0200_/tzF.SIunqwF18Dn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp4n6AACgkQ5xr2akVTsAF3BwCfYRi4CwfFuWsq2eRMKReVZaB7
ciMAnjkYuLxWTA8hkZV3cF2UxYVwZPt0
=xwu/
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Aug_2009_22_52_48_+0200_/tzF.SIunqwF18Dn--
