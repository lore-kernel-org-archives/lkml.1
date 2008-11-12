Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbYKLQAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbYKLQAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYKLQAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:00:11 -0500
Received: from 30.mail-out.ovh.net ([213.186.62.213]:48798 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754196AbYKLQAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:00:09 -0500
Message-ID: <491AFD7C.8090607@neotion.com>
Date: Wed, 12 Nov 2008 16:59:56 +0100
From: Neil Armstrong <narmstrong@neotion.com>
Reply-To: narmstrong@neotion.com
Organization: Neotion
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio: add ioctl callback
References: <491AF8D1.4060106@neotion.com> <20081112154919.GC2891@local>
In-Reply-To: <20081112154919.GC2891@local>
X-Enigmail-Version: 0.95.7
OpenPGP: id=1166F485
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9384B19AA45093E1731CBFF7"
X-Ovh-Tracer-Id: 18268007464602137745
X-Ovh-Remote: 82.236.40.173 (sop06-1-82-236-40-173.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9384B19AA45093E1731CBFF7
Content-Type: multipart/mixed;
 boundary="------------020400020108070200060507"

This is a multi-part message in MIME format.
--------------020400020108070200060507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Hans,

We need an ioctl callback because we need to query some values only
available when the irq handler is running.
For example, we have 3 types of reasons why the irq is triggered and
these bits are no more available when the irq is cleared.

The cleanest way to have this very specific information is to have a
dirty old ioctl returning this data.

Thanks for your time.

Neil

Hans J. Koch a =E9crit :
> On Wed, Nov 12, 2008 at 04:40:01PM +0100, Neil Armstrong wrote:
>  =20
>> Add an ioctl callback for uio devices.
>>    =20
>
> Hi Neil,
> sorry, but we don't want to have ioctl() for UIO. UIO devices should be=

> completely controllable through their mapped memory. Additional
> functions can be added by creating custom sysfs files. To switch the
> interrupt on and off, we have the irqcontrol hook in the write()
> function. I cannot imagine a case where ioctl() could be useful.
>
> You didn't mention why you want ioctl(). If you tell us the problem, we=

> can probably find a solution that uses the standard UIO interface.
>
> Thanks,
> Hans
>
>  =20
>> Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
>> ---
>>
>> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
>> index 2d2440c..38044fb 100644
>> --- a/drivers/uio/uio.c
>> +++ b/drivers/uio/uio.c
>> @@ -385,6 +385,18 @@ static unsigned int uio_poll(struct file *filep,
>> poll_table *wait)
>>      return 0;
>>  }
>> =20
>> +static int uio_ioctl(struct inode *inode, struct file *filep,
>> +            unsigned int cmd, unsigned long arg)
>> +{
>> +    struct uio_listener *listener =3D filep->private_data;
>> +    struct uio_device *idev =3D listener->dev;
>> +
>> +    if (idev->info->ioctl)
>> +        return idev->info->ioctl(idev->info, cmd, arg);
>> +
>> +    return -ENOSYS;
>> +}
>> +
>>  static ssize_t uio_read(struct file *filep, char __user *buf,
>>              size_t count, loff_t *ppos)
>>  {
>> @@ -590,6 +602,7 @@ static const struct file_operations uio_fops =3D {=

>>      .mmap        =3D uio_mmap,
>>      .poll        =3D uio_poll,
>>      .fasync        =3D uio_fasync,
>> +    .ioctl        =3D uio_ioctl,
>>  };
>> =20
>>  static int uio_major_init(void)
>> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
>> index cdf338d..e44e89b 100644
>> --- a/include/linux/uio_driver.h
>> +++ b/include/linux/uio_driver.h
>> @@ -68,6 +68,8 @@ struct uio_info {
>>      int (*open)(struct uio_info *info, struct inode *inode);
>>      int (*release)(struct uio_info *info, struct inode *inode);
>>      int (*irqcontrol)(struct uio_info *info, s32 irq_on);
>> +    int (*ioctl)(struct uio_info *info, unsigned int cmd,
>> +            unsigned long arg);
>>  };
>> =20
>>  extern int __must_check
>>    =20
>
>  =20
>> begin:vcard
>> fn:Neil Armstrong
>> n:Armstrong;Neil
>> org:Neotion;Neotion Sophia Antipolis
>> adr:;;;Sophia Antipolis;;;France
>> email;internet:narmstrong@neotion.com
>> title:Embedded Linux Software Engineer
>> tel;cell:0667474169
>> note:PGP 0x1166F485
>> x-mozilla-html:FALSE
>> url:http://www.neotion.com
>> version:2.1
>> end:vcard
>>
>>    =20
>
>
>  =20

--------------020400020108070200060507
Content-Type: text/x-vcard; charset=utf-8;
 name="narmstrong.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="narmstrong.vcf"

begin:vcard
fn:Neil Armstrong
n:Armstrong;Neil
org:Neotion;Neotion Sophia Antipolis
adr:;;;Sophia Antipolis;;;France
email;internet:narmstrong@neotion.com
title:Embedded Linux Software Engineer
tel;cell:0667474169
note:PGP 0x1166F485
x-mozilla-html:FALSE
url:http://www.neotion.com
version:2.1
end:vcard


--------------020400020108070200060507--

--------------enig9384B19AA45093E1731CBFF7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJGv1+b5rmahFm9IURAtI8AKC+EuaU+2Hjwy4sn+sdKeP3rPMdvgCgnXxU
JG6z5WuAEUURUOlePuXcsDU=
=ul+D
-----END PGP SIGNATURE-----

--------------enig9384B19AA45093E1731CBFF7--
