Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbYBZMcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbYBZMcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYBZMc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:32:26 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:4956 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751512AbYBZMcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:32:25 -0500
Date: Tue, 26 Feb 2008 13:32:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, i2c@lm-sensors.org,
       video4linux-list@redhat.com
Subject: Re: [PATCH] video: limit stack usage of ir-kbd-i2c.c
Message-ID: <20080226133222.7af260b2@hyperion.delvare>
In-Reply-To: <20080225205055.GA27455@joi>
References: <20080225205055.GA27455@joi>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcin,

On Mon, 25 Feb 2008 21:51:00 +0100, Marcin Slusarz wrote:
> ir_probe allocated struct i2c_client on stack;
> it's pretty big structure, so allocate it with kzalloc
> 
> make checkstack output without this patch:
> x059d ir_probe [ir-kbd-i2c]:                           1000
> 
> compile tested only
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/media/video/ir-kbd-i2c.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
> index 9851987..aec122f 100644
> --- a/drivers/media/video/ir-kbd-i2c.c
> +++ b/drivers/media/video/ir-kbd-i2c.c
> @@ -510,9 +510,9 @@ static int ir_probe(struct i2c_adapter *adap)
>  	static const int probe_cx88[] = { 0x18, 0x6b, 0x71, -1 };
>  	static const int probe_cx23885[] = { 0x6b, -1 };
>  	const int *probe = NULL;
> -	struct i2c_client c;
> +	struct i2c_client *c;
>  	unsigned char buf;
> -	int i,rc;
> +	int i, rc;
>  
>  	switch (adap->id) {
>  	case I2C_HW_B_BT848:
> @@ -537,19 +537,23 @@ static int ir_probe(struct i2c_adapter *adap)
>  	if (NULL == probe)
>  		return 0;
>  
> -	memset(&c,0,sizeof(c));
> -	c.adapter = adap;
> +	c = kzalloc(sizeof(*c), GFP_KERNEL);
> +	if (!c)
> +		return -ENOMEM;
> +
> +	c->adapter = adap;
>  	for (i = 0; -1 != probe[i]; i++) {
> -		c.addr = probe[i];
> -		rc = i2c_master_recv(&c,&buf,0);
> +		c->addr = probe[i];
> +		rc = i2c_master_recv(c, &buf, 0);
>  		dprintk(1,"probe 0x%02x @ %s: %s\n",
>  			probe[i], adap->name,
>  			(0 == rc) ? "yes" : "no");
>  		if (0 == rc) {
> -			ir_attach(adap,probe[i],0,0);
> +			ir_attach(adap, probe[i], 0, 0);
>  			break;
>  		}
>  	}
> +	kfree(c);
>  	return 0;
>  }
>  

While this works, I'd rather change the code to call i2c_transfer()
instead of i2c_master_recv(). i2c_transfer() is meant exactly for this
case (no i2c_client at hand.) This solves the stack usage problem
without requiring a temporary memory allocation:

* * * * *

Limit stack usage in ir_probe by calling i2c_transfer, which doesn't
require a struct i2c_client, instead of i2c_master_recv which does.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/media/video/ir-kbd-i2c.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- linux-2.6.25-rc3.orig/drivers/media/video/ir-kbd-i2c.c	2008-02-26 11:35:51.000000000 +0100
+++ linux-2.6.25-rc3/drivers/media/video/ir-kbd-i2c.c	2008-02-26 11:44:54.000000000 +0100
@@ -510,8 +510,11 @@ static int ir_probe(struct i2c_adapter *
 	static const int probe_cx88[] = { 0x18, 0x6b, 0x71, -1 };
 	static const int probe_cx23885[] = { 0x6b, -1 };
 	const int *probe = NULL;
-	struct i2c_client c;
-	unsigned char buf;
+	struct i2c_msg msg = {
+		.flags = I2C_M_RD,
+		.len = 0,
+		.buf = NULL,
+	};
 	int i,rc;
 
 	switch (adap->id) {
@@ -537,15 +540,13 @@ static int ir_probe(struct i2c_adapter *
 	if (NULL == probe)
 		return 0;
 
-	memset(&c,0,sizeof(c));
-	c.adapter = adap;
 	for (i = 0; -1 != probe[i]; i++) {
-		c.addr = probe[i];
-		rc = i2c_master_recv(&c,&buf,0);
+		msg.addr = probe[i];
+		rc = i2c_transfer(adap, &msg, 1);
 		dprintk(1,"probe 0x%02x @ %s: %s\n",
 			probe[i], adap->name,
-			(0 == rc) ? "yes" : "no");
-		if (0 == rc) {
+			(1 == rc) ? "yes" : "no");
+		if (1 == rc) {
 			ir_attach(adap,probe[i],0,0);
 			break;
 		}


Built-tested, I've also tested loading the ir-kbd-i2c driver on an
unsupported cx88 adapter. Review and more testing welcome.

-- 
Jean Delvare
