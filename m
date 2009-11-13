Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZKMKhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZKMKhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbZKMKhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:37:36 -0500
Received: from mail168c2.megamailservers.com ([69.49.111.68]:36656 "EHLO
	mail168c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564AbZKMKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:37:35 -0500
X-Authenticated-User: kristoffer.gaisler.com
Message-ID: <4AFD3644.1080907@gaisler.com>
Date: Fri, 13 Nov 2009 11:34:44 +0100
From: Kristoffer Glembo <kristoffer@gaisler.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070601 SeaMonkey/1.1.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: sparc tree build failure
References: <20091105185014.76dd0d31.sfr@canb.auug.org.au>	<20091104.235315.18303666.davem@davemloft.net> <20091105.000012.61292273.davem@davemloft.net>
In-Reply-To: <20091105.000012.61292273.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed just now that this patch broke the driver on LEON SPARC. It
does not find the root node by using of_find_node_by_name(NULL, "/").

I'm not sure whether this is because we build our OF tree wrong or if
it is an incorrect way of doing things. But if I instead change it to
of_find_node_by_path("/") it works fine.

Signed-off-by: Kristoffer Glembo <kristoffer@gaisler.com>

---
  drivers/serial/apbuart.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/apbuart.c b/drivers/serial/apbuart.c
index a1e9503..fe91319 100644
--- a/drivers/serial/apbuart.c
+++ b/drivers/serial/apbuart.c
@@ -609,7 +609,7 @@ static void grlib_apbuart_configure(void)
                 return;

         /* Get bus frequency */
-       rp = of_find_node_by_name(NULL, "/");
+       rp = of_find_node_by_path("/");
         rp = of_get_next_child(rp, NULL);
         prop = of_get_property(rp, "clock-frequency", NULL);
         freq_khz = *prop;
--
1.5.2.2


David Miller wrote:
> 
> Hmm, it took a tiny bit more than that :-)  Here's what I commited
> to fix this, thanks.
> 
> apbuart: Kill dependency on deprecated Sparc-only PROM interfaces.
> 
> Use the proper modern OF ones instead.
> 
> Noticed by Stephen Rothwell.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/serial/apbuart.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/serial/apbuart.c b/drivers/serial/apbuart.c
> index c7883a3..5f9dec3 100644
> --- a/drivers/serial/apbuart.c
> +++ b/drivers/serial/apbuart.c
> @@ -29,7 +29,6 @@
>  #include <linux/io.h>
>  #include <linux/serial_core.h>
>  #include <asm/irq.h>
> -#include <asm/oplib.h>
>  
>  #include "apbuart.h"
>  
> @@ -596,10 +595,9 @@ static struct of_platform_driver grlib_apbuart_of_driver = {
>  static void grlib_apbuart_configure(void)
>  {
>  	static int enum_done;
> -	struct device_node *np;
> +	struct device_node *np, *rp;
>  	struct uart_port *port = NULL;
> -
> -	int node;
> +	const u32 *prop;
>  	int freq_khz;
>  	int v = 0, d = 0;
>  	unsigned int addr;
> @@ -610,8 +608,10 @@ static void grlib_apbuart_configure(void)
>  		return;
>  
>  	/* Get bus frequency */
> -	node = prom_getchild(prom_root_node);
> -	freq_khz = prom_getint(node, "clock-frequency");
> +	rp = of_find_node_by_name(NULL, "/");
> +	rp = of_get_next_child(rp, NULL);
> +	prop = of_get_property(rp, "clock-frequency", NULL);
> +	freq_khz = *prop;
>  
>  	line = 0;
>  	for_each_matching_node(np, apbuart_match) {

