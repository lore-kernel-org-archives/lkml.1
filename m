Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYAND0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYAND0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 22:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYAND0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 22:26:22 -0500
Received: from web36712.mail.mud.yahoo.com ([209.191.85.46]:36077 "HELO
	web36712.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753645AbYAND0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 22:26:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=BRlgLK9EYxpXbAfi4MZQSj3thiQsEyutq7Nsav7xy1/H/IET3G6DhXEt25TwCIvK0NUewrc7giFxUqq89Jna3mQJm99QZN3/tFCBWS2mknEUTUteS1AjzfOLxedSZBCYBWiWpRwfne5M1VhRQgNHUDE2V9MxBlfvFd9vs4ULiZs=;
X-YMail-OSG: oTc0ZN4VM1kRL_KV2GCFSfMI6FNqVxTgb9xHNk82iXXfZoQQsJF3IDRIGd4uGjdXwxbJnrI4Ohohq4K5mitbb0RDbrd2dVDSKbrC57eIpVOU88TKSPkgaS3haFuYekIs1_b0D7Scyg--
Date: Sun, 13 Jan 2008 19:26:20 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080110010049.695da076.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <355699.38284.qm@web36712.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed,  2 Jan 2008 17:42:24 +1100 oakad@exemail.com.au wrote:
> 
> > From: Alex Dubov <oakad@yahoo.com>
> > 
> > Sony MemoryStick cards are used in many products manufactured by Sony. They
> > are available both as storage and as IO expansion cards. Currently, only
> > MemoryStick Pro storage cards are supported via TI FlashMedia MemoryStick
> > interface.
> > 
> 
> Will you be running a git tree for this?  If so, please send me the link.
> 
> Will this enable that thus-far useless slot on my Vaio?
> 
> Where did the info come from which enabled this driver to be written?  I
> thought Sony were super-secretive about this stuff?
> 

I'm going to set-up git tree, yes.

It should support some vaios (newer ones for sure), as far as I know.

The primary reference for the driver is this one:
http://zeniv.linux.org.uk/~winbond/ (link is somewhat slow, but works). Winbond developed GPLv2
driver for linux and there was enough info in their source code for my implementation (totally
different from their's). Some reverse engineering of the windows driver was needed too (for the TI
registers and such).



> 
> > @@ -0,0 +1,26 @@
> > +#
> > +# MemoryStick subsystem configuration
> > +#
> > +
> > +menuconfig MEMSTICK
> > +	tristate "Sony MemoryStick card support (EXPERIMENTAL)"
> > +	help
> > +	  Sony MemoryStick is a proprietary storage/extension card protocol.
> > +
> > +	  If you want MemoryStick support, you should say Y here and also
> > +	  to the specific driver for your MMC interface.
> 
> Are you sure this has enough dependencies?  CONFIG_TIFM_* for a start?

This is supposed to be a generic layer, akin to mmc. I have a jmicron backend in the works, and
windbond backend will be possible, too.


> 
> <fiddles with Kconfig>
> 
> We can create a config which has CONFIG_TIFM_CORE=m, CONFIG_MEMSTICK=y. 
> That might not work?
> 
> Anyway, please have a think about that.


Considering the previous point this should be ok.

> 
> > ...
> >
> > +
> > +struct mspro_sys_attr {
> > +	size_t                  size;
> > +	unsigned char           *data;
> > +	unsigned char           id;
> > +	char                    name[32];
> > +	struct device_attribute sys_attr;
> > +};
> > +
> > +struct mspro_attr_entry {
> > +	unsigned int  address;
> > +	unsigned int  size;
> > +	unsigned char id;
> > +	unsigned char reserved[3];
> > +} __attribute__((packed));
> > +
> > +struct mspro_attribute {
> > +	unsigned short          signature;
> > +	unsigned short          version;
> > +	unsigned char           count;
> > +	unsigned char           reserved[11];
> > +	struct mspro_attr_entry entries[];
> > +} __attribute__((packed));
> 
> Why are these packed?  Do they map onto something whcih hardware knows
> about?

Yes, of course; all structures with "packed" attribute correspond to appropriate protocol ones
(the endianness is tweaked as needed - most, but not all fields, are big-endian).

> >
> > ...
> >
> > +struct mspro_block_data {
> > +	struct memstick_dev   *card;
> > +	unsigned int          usage_count;
> > +	struct gendisk        *disk;
> > +	struct request_queue  *queue;
> > +	spinlock_t            q_lock;
> > +	wait_queue_head_t     q_wait;
> > +	struct task_struct    *q_thread;
> > +
> > +	unsigned short        page_size;
> > +	unsigned short        cylinders;
> > +	unsigned short        heads;
> > +	unsigned short        sectors_per_track;
> > +
> > +	unsigned char         system;
> > +	unsigned char         read_only:1,
> > +			      active:1,
> > +			      has_request:1,
> > +			      data_dir:1;
> 
> You're aware that these four fields occupy the same machine word and that
> the compiler provides no locking?  So if one thread attempts to modify
> "read_only" while another modifies "has_request", one can corrupt the work
> of the other?
> 
> If this is indeed safe then a comment here whcih clearly explains that
> would be useful.

The access to these fields should be exclusively under q_lock (I'll check the locking again, just
to make sure). After all, the same applies to old fashioned bit masks.

> 
> > +}
> > +
> > +static ssize_t mspro_block_attr_show_modelname(struct device *dev,
> > +					       struct device_attribute *attr,
> > +					       char *buffer)
> > +{
> > +	struct mspro_sys_attr *x_attr = container_of(attr,
> > +						     struct mspro_sys_attr,
> > +						     sys_attr);
> > +
> > +	return snprintf(buffer, PAGE_SIZE, "%s", x_attr->data);
> > +}
> >
> > ...
> >
> > +static int mspro_block_sysfs_register(struct memstick_dev *card)
> > +{
> > +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> > +	int cnt, rc = 0;
> > +
> > +	for (cnt = 0; cnt < msb->attr_count; cnt++) {
> > +		rc = device_create_file(&card->dev,
> > +					&msb->attributes[cnt].sys_attr);
> > +
> > +		if (rc) {
> > +			if (cnt) {
> > +				for (cnt--; cnt >= 0; cnt--)
> 
> ow. my brain hurts.
> 
> The `if (cnt)' is actually unneeded.  But if it were mine I'd be doing
> something simpler and obviouser here.  Like `for (i = 0; i < cnt; i++)'
> simple == good.  !simple == !.
> 
> > +					device_remove_file(&card->dev,
> > +							   &msb->attributes[cnt]
> > +								.sys_attr);
> > +			}
> > +			break;
> > +		}
> > +	}
> > +	return rc;
> > +}
> 
> Could we be using attribute groups for all this?

The idea here is that MSPro media have an attribute namespace, which may contain various entries.
Some of them I know how to decode, others I still want to be presented in sysfs for further study
(as hex dumps). Sysfs attr group should be fine, but I was not aware that such thing exists.

> > > ...
> >
> >
> > +static int mspro_block_queue_thread(void *data)
> > +{
> > +	struct memstick_dev *card = data;
> > +	struct memstick_host *host = card->host;
> > +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> > +	struct request *req;
> > +	unsigned long flags;
> > +
> > +	while (1) {
> > +		wait_event(msb->q_wait, mspro_block_has_request(msb));
> > +		dev_dbg(&card->dev, "thread iter\n");
> > +
> > +		spin_lock_irqsave(&msb->q_lock, flags);
> > +		req = elv_next_request(msb->queue);
> > +		dev_dbg(&card->dev, "next req %p\n", req);
> > +		if (!req) {
> > +			msb->has_request = 0;
> > +			if (kthread_should_stop()) {
> > +				spin_unlock_irqrestore(&msb->q_lock, flags);
> > +				break;
> > +			}
> > +		} else
> > +			msb->has_request = 1;
> > +		spin_unlock_irqrestore(&msb->q_lock, flags);
> > +
> > +		if (req) {
> > +			mutex_lock(&host->lock);
> > +			mspro_block_process_request(card, req);
> > +			mutex_unlock(&host->lock);
> > +		}
> > +	}
> 
> Should this have a try_to_freeze() in it?

The thread is stopped on suspend and restarted on resume.It works on my machine.

> > ...
> >
> > +static int mspro_block_resume(struct memstick_dev *card)
> > +{
> > +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> > +	unsigned long flags;
> > +	int rc = 0;
> > +
> > +#ifdef CONFIG_MEMSTICK_UNSAFE_RESUME
> > +
> > +	struct mspro_block_data *new_msb;
> > +	struct memstick_host *host = card->host;
> > +	unsigned char cnt;
> > +
> > +	mutex_lock(&host->lock);
> > +	new_msb = kzalloc(sizeof(struct mspro_block_data), GFP_KERNEL);
> 
> If anything takes host->lock on the IO path then there might be a deadlock
> here.  GFP_NOIO, perhaps.  or just swap these two lines.


There's no IO path at this point, as IO thread was stopped on suspend. The fine point here is that
thread is restarted only with "UNSAFE_RESUME" set, otherwise the block device just sits dead in
the water waiting for the bus driver to kick it out and run the media detection routine anew.


> > +inline void *memstick_priv(struct memstick_host *host)
> > +{
> > +	return (void *)host->private;
> > +}
> > +
> > +inline void *memstick_get_drvdata(struct memstick_dev *card)
> > +{
> > +	return dev_get_drvdata(&card->dev);
> > +}
> > +
> > +inline void memstick_set_drvdata(struct memstick_dev *card, void *data)
> > +{
> > +	dev_set_drvdata(&card->dev, data);
> > +}
> 
> static inline.
> 

Somebody was already kind enough to fix this.

I hope it'll be ok for me to address the rest of the issues with incremental patches.I expect to
have a web accessible git within a few days.



      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
