Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZKKN6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZKKN6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 08:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZKKN6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 08:58:19 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:58347 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZKKN6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 08:58:18 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AFAC319.8040005@cam.ac.uk>
Date: Wed, 11 Nov 2009 13:58:49 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091029)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de
Subject: Re: [PTCH -next] staging/iio: fix ring buffer build
References: <20091109192246.aa0dfd93.sfr@canb.auug.org.au> <20091110090428.08797a9a.randy.dunlap@oracle.com>
In-Reply-To: <20091110090428.08797a9a.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> max1363 uses both the iio hardware ring buffer and software
> ring buffer interfaces, but its Makefile and Kconfig do not
> reflect that usage, so its build breaks.  Add a new Kconfig
> symbol to reflect that usage and change max1363.h & Makefile
> to use the new Kconfig symbol.
Hi Randy,

Thanks for the fix.

This is fine for now though I suspect there are similar cases
in some of the other IIO drivers.  Will have a look when I have
a few mins. The structure of the relevant code will change again
when we add support for multiple ring buffer implementations
(needed to phase this one out as it is hideous ;), but
that isn't going to happen for a least a couple of weeks.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/adc/Kconfig   |    9 +++++++++
>  drivers/staging/iio/adc/Makefile  |    2 +-
>  drivers/staging/iio/adc/max1363.h |    6 +++---
>  3 files changed, 13 insertions(+), 4 deletions(-)
> 
> --- linux-next-20091109.orig/drivers/staging/iio/adc/Kconfig
> +++ linux-next-20091109/drivers/staging/iio/adc/Kconfig
> @@ -12,3 +12,12 @@ config MAX1363
>  	  convertors (ADC). (max1361, max1362, max1363, max1364, max1136,
>  	  max1136, max1137, max1138, max1139, max1236, max1237, max11238,
>  	  max1239) Provides direct access via sysfs.
> +
> +config MAX1363_RING_BUFFER
> +	bool "MAXIM max1363: use ring buffer"
> +	depends on MAX1363
> +	select IIO_RING_BUFFER
> +	select IIO_SW_RING
> +	help
> +	  Say yes here to include ring buffer support in the MAX1363
> +	  ADC driver.
> --- linux-next-20091109.orig/drivers/staging/iio/adc/Makefile
> +++ linux-next-20091109/drivers/staging/iio/adc/Makefile
> @@ -3,6 +3,6 @@
>  #
>  
>  max1363-y := max1363_core.o
> -max1363-$(CONFIG_IIO_RING_BUFFER) += max1363_ring.o
> +max1363-$(CONFIG_MAX1363_RING_BUFFER) += max1363_ring.o
>  
>  obj-$(CONFIG_MAX1363) += max1363.o
> --- linux-next-20091109.orig/drivers/staging/iio/adc/max1363.h
> +++ linux-next-20091109/drivers/staging/iio/adc/max1363.h
> @@ -228,7 +228,7 @@ struct max1363_state {
>  	struct iio_trigger		*trig;
>  	struct regulator		*reg;
>  };
> -#ifdef CONFIG_IIO_RING_BUFFER
> +#ifdef CONFIG_MAX1363_RING_BUFFER
>  
>  ssize_t max1363_scan_from_ring(struct device *dev,
>  			       struct device_attribute *attr,
> @@ -239,7 +239,7 @@ void max1363_ring_cleanup(struct iio_dev
>  int max1363_initialize_ring(struct iio_ring_buffer *ring);
>  void max1363_uninitialize_ring(struct iio_ring_buffer *ring);
>  
> -#else /* CONFIG_IIO_RING_BUFFER */
> +#else /* CONFIG_MAX1363_RING_BUFFER */
>  
>  static inline void max1363_uninitialize_ring(struct iio_ring_buffer *ring)
>  {
> @@ -265,5 +265,5 @@ max1363_register_ring_funcs_and_init(str
>  };
>  
>  static inline void max1363_ring_cleanup(struct iio_dev *indio_dev) {};
> -#endif /* CONFIG_IIO_RING_BUFFER */
> +#endif /* CONFIG_MAX1363_RING_BUFFER */
>  #endif /* _MAX1363_H_ */
> 

