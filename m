Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbYETF4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbYETF4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 01:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYETF4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 01:56:12 -0400
Received: from aksay.ru ([80.254.111.40]:38101 "EHLO aksay.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYETF4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 01:56:11 -0400
Date: Tue, 20 May 2008 09:52:02 +0400
From: Andrey Panin <pazke@pazke.donpac.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH 14/57] ibmasr: coding style, locking verify
Message-ID: <20080520055202.GB17237@pazke.donpac.ru>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
	linux-kernel@vger.kernel.org, wim@iguana.be
References: <20080519124659.31722.51847.stgit@core> <20080519130603.31722.28573.stgit@core>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <20080519130603.31722.28573.stgit@core>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 140, 05 19, 2008 at 02:06:03PM +0100, Alan Cox wrote:
> From: Alan Cox <alan@redhat.com>
>=20
> There is a new #if 0 section here which is a suggested fix for the horrib=
le
> PCI hack in the existing code. Would be good if someone with a box that u=
ses
> this device could test it.

Patch looks good, thank you. I'll test it as soon as I can. I need to find
unused IBM server first :)

Unfortunately I don't have suitable machine to test the suggested fix.

> ---
>=20
>  drivers/watchdog/ibmasr.c |  149 ++++++++++++++++++++++++++-------------=
------
>  1 files changed, 87 insertions(+), 62 deletions(-)
>=20
>=20
> diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
> index 94155f6..6824bf8 100644
> --- a/drivers/watchdog/ibmasr.c
> +++ b/drivers/watchdog/ibmasr.c
> @@ -19,9 +19,8 @@
>  #include <linux/miscdevice.h>
>  #include <linux/watchdog.h>
>  #include <linux/dmi.h>
> -
> -#include <asm/io.h>
> -#include <asm/uaccess.h>
> +#include <linux/io.h>
> +#include <linux/uaccess.h>
> =20
> =20
>  enum {
> @@ -70,10 +69,13 @@ static char asr_expect_close;
>  static unsigned int asr_type, asr_base, asr_length;
>  static unsigned int asr_read_addr, asr_write_addr;
>  static unsigned char asr_toggle_mask, asr_disable_mask;
> +static spinlock_t asr_lock;
> =20
> -static void asr_toggle(void)
> +static void __asr_toggle(void)
>  {
> -	unsigned char reg =3D inb(asr_read_addr);
> +	unsigned char reg;
> +
> +	reg =3D inb(asr_read_addr);
> =20
>  	outb(reg & ~asr_toggle_mask, asr_write_addr);
>  	reg =3D inb(asr_read_addr);
> @@ -83,12 +85,21 @@ static void asr_toggle(void)
> =20
>  	outb(reg & ~asr_toggle_mask, asr_write_addr);
>  	reg =3D inb(asr_read_addr);
> +	spin_unlock(&asr_lock);
> +}
> +
> +static void asr_toggle(void)
> +{
> +	spin_lock(&asr_lock);
> +	__asr_toggle();
> +	spin_unlock(&asr_lock);
>  }
> =20
>  static void asr_enable(void)
>  {
>  	unsigned char reg;
> =20
> +	spin_lock(&asr_lock);
>  	if (asr_type =3D=3D ASMTYPE_TOPAZ) {
>  		/* asr_write_addr =3D=3D asr_read_addr */
>  		reg =3D inb(asr_read_addr);
> @@ -99,17 +110,21 @@ static void asr_enable(void)
>  		 * First make sure the hardware timer is reset by toggling
>  		 * ASR hardware timer line.
>  		 */
> -		asr_toggle();
> +		__asr_toggle();
> =20
>  		reg =3D inb(asr_read_addr);
>  		outb(reg & ~asr_disable_mask, asr_write_addr);
>  	}
>  	reg =3D inb(asr_read_addr);
> +	spin_unlock(&asr_lock);
>  }
> =20
>  static void asr_disable(void)
>  {
> -	unsigned char reg =3D inb(asr_read_addr);
> +	unsigned char reg;
> +
> +	spin_lock(&asr_lock);
> +	reg =3D inb(asr_read_addr);
> =20
>  	if (asr_type =3D=3D ASMTYPE_TOPAZ)
>  		/* asr_write_addr =3D=3D asr_read_addr */
> @@ -122,6 +137,7 @@ static void asr_disable(void)
>  		outb(reg | asr_disable_mask, asr_write_addr);
>  	}
>  	reg =3D inb(asr_read_addr);
> +	spin_unlock(&asr_lock);
>  }
> =20
>  static int __init asr_get_base_address(void)
> @@ -133,7 +149,8 @@ static int __init asr_get_base_address(void)
> =20
>  	switch (asr_type) {
>  	case ASMTYPE_TOPAZ:
> -		/* SELECT SuperIO CHIP FOR QUERYING (WRITE 0x07 TO BOTH 0x2E and 0x2F)=
 */
> +		/* SELECT SuperIO CHIP FOR QUERYING
> +		   (WRITE 0x07 TO BOTH 0x2E and 0x2F) */
>  		outb(0x07, 0x2e);
>  		outb(0x07, 0x2f);
> =20
> @@ -154,14 +171,26 @@ static int __init asr_get_base_address(void)
> =20
>  	case ASMTYPE_JASPER:
>  		type =3D "Jaspers ";
> -
> -		/* FIXME: need to use pci_config_lock here, but it's not exported */
> +#if 0
> +		u32 r;
> +		/* Suggested fix */
> +		pdev =3D pci_get_bus_and_slot(0, DEVFN(0x1f, 0));
> +		if (pdev =3D=3D NULL)
> +			return -ENODEV;
> +		pci_read_config_dword(pdev, 0x58, &r);
> +		asr_base =3D r & 0xFFFE;
> +		pci_dev_put(pdev);
> +#else
> +		/* FIXME: need to use pci_config_lock here,
> +		   but it's not exported */
> =20
>  /*		spin_lock_irqsave(&pci_config_lock, flags);*/
> =20
>  		/* Select the SuperIO chip in the PCI I/O port register */
>  		outl(0x8000f858, 0xcf8);
> =20
> +		/* BUS 0, Slot 1F, fnc 0, offset 58 */
> +
>  		/*
>  		 * Read the base address for the SuperIO chip.
>  		 * Only the lower 16 bits are valid, but the address is word
> @@ -170,7 +199,7 @@ static int __init asr_get_base_address(void)
>  		asr_base =3D inl(0xcfc) & 0xfffe;
> =20
>  /*		spin_unlock_irqrestore(&pci_config_lock, flags);*/
> -
> +#endif
>  		asr_read_addr =3D asr_write_addr =3D
>  			asr_base + JASPER_ASR_REG_OFFSET;
>  		asr_toggle_mask =3D JASPER_ASR_TOGGLE_MASK;
> @@ -241,11 +270,10 @@ static ssize_t asr_write(struct file *file, const c=
har __user *buf,
>  	return count;
>  }
> =20
> -static int asr_ioctl(struct inode *inode, struct file *file,
> -		     unsigned int cmd, unsigned long arg)
> +static long asr_ioctl(struct file *file, unsigned int cmd, unsigned long=
 arg)
>  {
>  	static const struct watchdog_info ident =3D {
> -		.options =3D	WDIOF_KEEPALIVEPING |=20
> +		.options =3D	WDIOF_KEEPALIVEPING |
>  				WDIOF_MAGICCLOSE,
>  		.identity =3D	"IBM ASR"
>  	};
> @@ -254,53 +282,45 @@ static int asr_ioctl(struct inode *inode, struct fi=
le *file,
>  	int heartbeat;
> =20
>  	switch (cmd) {
> -		case WDIOC_GETSUPPORT:
> -			return copy_to_user(argp, &ident, sizeof(ident)) ?
> -				-EFAULT : 0;
> -
> -		case WDIOC_GETSTATUS:
> -		case WDIOC_GETBOOTSTATUS:
> -			return put_user(0, p);
> -
> -		case WDIOC_KEEPALIVE:
> +	case WDIOC_GETSUPPORT:
> +		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
> +	case WDIOC_GETSTATUS:
> +	case WDIOC_GETBOOTSTATUS:
> +		return put_user(0, p);
> +	case WDIOC_KEEPALIVE:
> +		asr_toggle();
> +		return 0;
> +	/*
> +	 * The hardware has a fixed timeout value, so no WDIOC_SETTIMEOUT
> +	 * and WDIOC_GETTIMEOUT always returns 256.
> +	 */
> +	case WDIOC_GETTIMEOUT:
> +		heartbeat =3D 256;
> +		return put_user(heartbeat, p);
> +	case WDIOC_SETOPTIONS:
> +	{
> +		int new_options, retval =3D -EINVAL;
> +		if (get_user(new_options, p))
> +			return -EFAULT;
> +		if (new_options & WDIOS_DISABLECARD) {
> +			asr_disable();
> +			retval =3D 0;
> +		}
> +		if (new_options & WDIOS_ENABLECARD) {
> +			asr_enable();
>  			asr_toggle();
> -			return 0;
> -
> -		/*
> -		 * The hardware has a fixed timeout value, so no WDIOC_SETTIMEOUT
> -		 * and WDIOC_GETTIMEOUT always returns 256.
> -		 */
> -		case WDIOC_GETTIMEOUT:
> -			heartbeat =3D 256;
> -			return put_user(heartbeat, p);
> -
> -		case WDIOC_SETOPTIONS: {
> -			int new_options, retval =3D -EINVAL;
> -
> -			if (get_user(new_options, p))
> -				return -EFAULT;
> -
> -			if (new_options & WDIOS_DISABLECARD) {
> -				asr_disable();
> -				retval =3D 0;
> -			}
> -
> -			if (new_options & WDIOS_ENABLECARD) {
> -				asr_enable();
> -				asr_toggle();
> -				retval =3D 0;
> -			}
> -
> -			return retval;
> +			retval =3D 0;
>  		}
> +		return retval;
> +	}
> +	default:
> +		return -ENOTTY;
>  	}
> -
> -	return -ENOTTY;
>  }
> =20
>  static int asr_open(struct inode *inode, struct file *file)
>  {
> -	if(test_and_set_bit(0, &asr_is_open))
> +	if (test_and_set_bit(0, &asr_is_open))
>  		return -EBUSY;
> =20
>  	asr_toggle();
> @@ -314,7 +334,8 @@ static int asr_release(struct inode *inode, struct fi=
le *file)
>  	if (asr_expect_close =3D=3D 42)
>  		asr_disable();
>  	else {
> -		printk(KERN_CRIT PFX "unexpected close, not stopping watchdog!\n");
> +		printk(KERN_CRIT PFX
> +				"unexpected close, not stopping watchdog!\n");
>  		asr_toggle();
>  	}
>  	clear_bit(0, &asr_is_open);
> @@ -323,12 +344,12 @@ static int asr_release(struct inode *inode, struct =
file *file)
>  }
> =20
>  static const struct file_operations asr_fops =3D {
> -	.owner =3D	THIS_MODULE,
> -	.llseek	=3D	no_llseek,
> -	.write =3D	asr_write,
> -	.ioctl =3D	asr_ioctl,
> -	.open =3D		asr_open,
> -	.release =3D	asr_release,
> +	.owner =3D		THIS_MODULE,
> +	.llseek	=3D		no_llseek,
> +	.write =3D		asr_write,
> +	.unlocked_ioctl =3D	asr_ioctl,
> +	.open =3D			asr_open,
> +	.release =3D		asr_release,
>  };
> =20
>  static struct miscdevice asr_miscdev =3D {
> @@ -367,6 +388,8 @@ static int __init ibmasr_init(void)
>  	if (!asr_type)
>  		return -ENODEV;
> =20
> +	spin_lock_init(&asr_lock);
> +
>  	rc =3D asr_get_base_address();
>  	if (rc)
>  		return rc;
> @@ -395,7 +418,9 @@ module_init(ibmasr_init);
>  module_exit(ibmasr_exit);
> =20
>  module_param(nowayout, int, 0);
> -MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (def=
ault=3D" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> +MODULE_PARM_DESC(nowayout,
> +	"Watchdog cannot be stopped once started (default=3D"
> +				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> =20
>  MODULE_DESCRIPTION("IBM Automatic Server Restart driver");
>  MODULE_AUTHOR("Andrey Panin");
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIMmcCIWZCBzwS8mkRApkkAJ9sbwJYEusi7fA5K7S+GKio3Sa0rwCfZrcR
s1pXn4ha8y+gFmom7KURt08=
=wi5Z
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
