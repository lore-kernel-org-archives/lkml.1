Return-Path: <linux-kernel-owner+w=401wt.eu-S1764769AbYBZVES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764769AbYBZVES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYBZVEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:04:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:16907 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbYBZVEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:04:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=DZKRZlCtpIC3rDpjVM2nROElEuSZVOCmRGZ08DyPijazRWNBwbtgS39byghqmLlPUFwYT5+yNewk/mMIHKRu0ouMPgSzNs+XtKW96YDhyJmurTweByS2/lN3u0srJBh9qVKObvATkVTypLNGKlklJ9XDJNgILp5M8SOOgJiXyKY=
Date: Tue, 26 Feb 2008 22:03:16 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, i2c@lm-sensors.org,
       video4linux-list@redhat.com
Subject: Re: [PATCH] video: limit stack usage of ir-kbd-i2c.c
Message-ID: <20080226210307.GA6085@joi>
References: <20080225205055.GA27455@joi> <20080226133222.7af260b2@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226133222.7af260b2@hyperion.delvare>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 01:32:22PM +0100, Jean Delvare wrote:
> Hi Marcin,
> 
> On Mon, 25 Feb 2008 21:51:00 +0100, Marcin Slusarz wrote:
> > ir_probe allocated struct i2c_client on stack;
> > it's pretty big structure, so allocate it with kzalloc
> > 
> > make checkstack output without this patch:
> > x059d ir_probe [ir-kbd-i2c]:                           1000
> > 
> > compile tested only
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Cc: Jean Delvare <khali@linux-fr.org>
> > ---
> >  drivers/media/video/ir-kbd-i2c.c |   18 +++++++++++-------
> >  1 files changed, 11 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
> > index 9851987..aec122f 100644
> > --- a/drivers/media/video/ir-kbd-i2c.c
> > +++ b/drivers/media/video/ir-kbd-i2c.c
> > @@ -510,9 +510,9 @@ static int ir_probe(struct i2c_adapter *adap)
> >  	static const int probe_cx88[] = { 0x18, 0x6b, 0x71, -1 };
> >  	static const int probe_cx23885[] = { 0x6b, -1 };
> >  	const int *probe = NULL;
> > -	struct i2c_client c;
> > +	struct i2c_client *c;
> >  	unsigned char buf;
> > -	int i,rc;
> > +	int i, rc;
> >  
> >  	switch (adap->id) {
> >  	case I2C_HW_B_BT848:
> > @@ -537,19 +537,23 @@ static int ir_probe(struct i2c_adapter *adap)
> >  	if (NULL == probe)
> >  		return 0;
> >  
> > -	memset(&c,0,sizeof(c));
> > -	c.adapter = adap;
> > +	c = kzalloc(sizeof(*c), GFP_KERNEL);
> > +	if (!c)
> > +		return -ENOMEM;
> > +
> > +	c->adapter = adap;
> >  	for (i = 0; -1 != probe[i]; i++) {
> > -		c.addr = probe[i];
> > -		rc = i2c_master_recv(&c,&buf,0);
> > +		c->addr = probe[i];
> > +		rc = i2c_master_recv(c, &buf, 0);
> >  		dprintk(1,"probe 0x%02x @ %s: %s\n",
> >  			probe[i], adap->name,
> >  			(0 == rc) ? "yes" : "no");
> >  		if (0 == rc) {
> > -			ir_attach(adap,probe[i],0,0);
> > +			ir_attach(adap, probe[i], 0, 0);
> >  			break;
> >  		}
> >  	}
> > +	kfree(c);
> >  	return 0;
> >  }
> >  
> 
> While this works, I'd rather change the code to call i2c_transfer()
> instead of i2c_master_recv(). i2c_transfer() is meant exactly for this
> case (no i2c_client at hand.) This solves the stack usage problem
> without requiring a temporary memory allocation:
> 
> * * * * *
> 
> Limit stack usage in ir_probe by calling i2c_transfer, which doesn't
> require a struct i2c_client, instead of i2c_master_recv which does.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/media/video/ir-kbd-i2c.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> --- linux-2.6.25-rc3.orig/drivers/media/video/ir-kbd-i2c.c	2008-02-26 11:35:51.000000000 +0100
> +++ linux-2.6.25-rc3/drivers/media/video/ir-kbd-i2c.c	2008-02-26 11:44:54.000000000 +0100
> @@ -510,8 +510,11 @@ static int ir_probe(struct i2c_adapter *
>  	static const int probe_cx88[] = { 0x18, 0x6b, 0x71, -1 };
>  	static const int probe_cx23885[] = { 0x6b, -1 };
>  	const int *probe = NULL;
> -	struct i2c_client c;
> -	unsigned char buf;
> +	struct i2c_msg msg = {
> +		.flags = I2C_M_RD,
> +		.len = 0,
> +		.buf = NULL,
> +	};
>  	int i,rc;
>  
>  	switch (adap->id) {
> @@ -537,15 +540,13 @@ static int ir_probe(struct i2c_adapter *
>  	if (NULL == probe)
>  		return 0;
>  
> -	memset(&c,0,sizeof(c));
> -	c.adapter = adap;
>  	for (i = 0; -1 != probe[i]; i++) {
> -		c.addr = probe[i];
> -		rc = i2c_master_recv(&c,&buf,0);
> +		msg.addr = probe[i];
> +		rc = i2c_transfer(adap, &msg, 1);
>  		dprintk(1,"probe 0x%02x @ %s: %s\n",
>  			probe[i], adap->name,
> -			(0 == rc) ? "yes" : "no");
> -		if (0 == rc) {
> +			(1 == rc) ? "yes" : "no");
> +		if (1 == rc) {
>  			ir_attach(adap,probe[i],0,0);
>  			break;
>  		}
> 
> 
> Built-tested, I've also tested loading the ir-kbd-i2c driver on an
> unsupported cx88 adapter. Review and more testing welcome.
I know nothing about I2C API, so I can't comment on correctness of this patch ;)

Do you have an idea (or patch :D) how to solve this:
0x00000234 v4l_compat_translate_ioctl [v4l1-compat]:    1376
? That's on top of my make checkstack output

Marcin
