Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbXEUETQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbXEUETQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXEUETG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:19:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303AbXEUETF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:19:05 -0400
Date: Sun, 20 May 2007 21:16:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2o: fix notifiers when max_drivers is configured
Message-Id: <20070520211659.91c84574.akpm@linux-foundation.org>
In-Reply-To: <20070520142728.GB4207@APFDCB5C>
References: <20070520142728.GB4207@APFDCB5C>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 23:27:28 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Maxinum number of I2O drivers which could be registered is
> configurable by max_drivers module parameter.
> 
> But the module parameter is ignored and default value (I2O_MAX_DRIVERS = 8)
> is used in the loops to notify all registered drivers.
> 
> Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> ---
>  drivers/message/i2o/driver.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> Index: 2.6-mm/drivers/message/i2o/driver.c
> ===================================================================
> --- 2.6-mm.orig/drivers/message/i2o/driver.c
> +++ 2.6-mm/drivers/message/i2o/driver.c
> @@ -20,6 +20,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> +#include <linux/log2.h>
>  #include "core.h"
>  
>  #define OSM_NAME	"i2o"
> @@ -260,7 +261,7 @@ void i2o_driver_notify_controller_add_al
>  	int i;
>  	struct i2o_driver *drv;
>  
> -	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
> +	for (i = 0; i < i2o_max_drivers; i++) {
>  		drv = i2o_drivers[i];
>  
>  		if (drv)
> @@ -280,7 +281,7 @@ void i2o_driver_notify_controller_remove
>  	int i;
>  	struct i2o_driver *drv;
>  
> -	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
> +	for (i = 0; i < i2o_max_drivers; i++) {
>  		drv = i2o_drivers[i];
>  
>  		if (drv)
> @@ -299,7 +300,7 @@ void i2o_driver_notify_device_add_all(st
>  	int i;
>  	struct i2o_driver *drv;
>  
> -	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
> +	for (i = 0; i < i2o_max_drivers; i++) {
>  		drv = i2o_drivers[i];
>  
>  		if (drv)
> @@ -318,7 +319,7 @@ void i2o_driver_notify_device_remove_all
>  	int i;
>  	struct i2o_driver *drv;
>  
> -	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
> +	for (i = 0; i < i2o_max_drivers; i++) {
>  		drv = i2o_drivers[i];
>  
>  		if (drv)
> @@ -340,8 +341,7 @@ int __init i2o_driver_init(void)
>  	spin_lock_init(&i2o_drivers_lock);
>  
>  	if ((i2o_max_drivers < 2) || (i2o_max_drivers > 64) ||
> -	    ((i2o_max_drivers ^ (i2o_max_drivers - 1)) !=
> -	     (2 * i2o_max_drivers - 1))) {
> +	    !is_power_of_2(i2o_max_drivers)) {
>  		osm_warn("max_drivers set to %d, but must be >=2 and <= 64 and "
>  			 "a power of 2\n", i2o_max_drivers);
>  		i2o_max_drivers = I2O_MAX_DRIVERS;
> @@ -349,7 +349,7 @@ int __init i2o_driver_init(void)
>  	osm_info("max drivers = %d\n", i2o_max_drivers);
>  
>  	i2o_drivers =
> -	    kzalloc(i2o_max_drivers * sizeof(*i2o_drivers), GFP_KERNEL);
> +	    kcalloc(i2o_max_drivers, sizeof(*i2o_drivers), GFP_KERNEL);
>  	if (!i2o_drivers)
>  		return -ENOMEM;
>  

Is there any particular reason why i2o_max_drivers must be a power of two? 
It seems a peculiar constraint.
