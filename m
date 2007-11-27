Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbXK0EdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbXK0EdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbXK0EdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:33:17 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:44947 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbXK0EdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:33:16 -0500
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 23:33:16 EST
From: Konrad Rzeszutek <konrad@darnok.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Date: Mon, 26 Nov 2007 23:23:31 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com
References: <20071126225642.GA7973@andromeda.dapyr.net> <20071127033138.GB30770@kroah.com>
In-Reply-To: <20071127033138.GB30770@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711262323.35416.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 November 2007 22:31:38 Greg KH wrote:
> On Mon, Nov 26, 2007 at 06:56:42PM -0400, Konrad Rzeszutek wrote:
> > +/*
> > + *  Routines for reading of the iBFT data in a human readable fashion.
> > + */
> > +ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
> > +				 struct ibft_attribute *attr,
> > +				 char *buf)
> > +{
.. snip..
> > +
> > +	str += sprintf_ipaddr(str, "isns", initiator->isns_server);
> > +	str += sprintf_ipaddr(str, "slp", initiator->slp_server);
.. snip ..
>
> sysfs files have ONE VALUE PER FILE, not a whole bunch of different
> things in a single file.  Please fix this.

No problem. I will have that shortly posted.

>
> > +
> > +ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
> > +			   struct ibft_attribute *attr,
> > +			   char *buf)
.. snip.. 
> > +		str += sprintf_ipaddr(str, "giaddr", nic->gateway);
> > +		str += sprintf_ipaddr(str, "dnsaddr1", nic->primary_dns);
>
> Same here.

Yup. 
>
> > +ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
> > +			      struct ibft_attribute *attr,
> > +			      char *buf)
> > +{
.. snip..
> > +}
>
> Same here, are we writing a novella or something to userspace?  :)

Hehe.. I will make it simpler :-)

>
> > +ssize_t ibft_attr_show_disk(struct ibft_kobject *dev,
> > +			    struct ibft_attribute *ibft_attr,
> > +			    char *buf)
> > +{
.. snip ..
> > +}
>
> And here, do I need to go on?

I will have a new version posted quite shortly.

>
> > +ssize_t ibft_attr_show_mac(struct ibft_kobject *entry,
> > +			   struct ibft_attribute *attr,
> > +			   char *buf)
> > +{
..snip..
> > +
> > +	memcpy(buf, attr->nic->mac, len);
> > +
> > +	return len;
> > +}
>
> Is mac a user readable string?  Then perhaps a simple sprintf would work
> instead, as I doubt you are including a \n here...

It was meant to be as a binary value. But that doesn't fit in sysfs directory, 
so let me make it use sprintf here.

>
> > +/*
> > + * The main routine which allows the user to read the IBFT data.
> > + */
> > +static ssize_t ibft_show_attribute(struct kobject *kobj,
> > +				   struct attribute *attr,
> > +				   char *buf)
> > +{
..snip..
> > +
> > +static struct sysfs_ops ibft_attr_ops = {
> > +	.show = ibft_show_attribute,
> > +};
>
> I think this whole mess can go away in the new rework Kay and I have
> done, please document this whole thing and I'll see what I can do.

Absolutely.

>
> > +struct ibft_control {
> > +    struct ibft_hdr hdr;
> > +    u16 extensions;
> > +    u16 initiator_off;
> > +    u16 nic0_off;
> > +    u16 tgt0_off;
> > +    u16 nic1_off;
> > +    u16 tgt1_off;
> > +} __attribute__((__packed__));
>
> Did we loose tabs for some reason?  I'm guessing your editor is not
> showing them properly, nor did you use scripts/checkpatch.pl :(

I did use checkpatch.pl v0.99 downloaded somewhere from the web. I hadn't
realized it was now residing in scripts/checkpatch.pl - and from now on I will 
use that.

>
> > +#if defined(CONFIG_ISCSI_IBFT) || defined(CONFIG_ISCSI_IBFT_MODULE)
..snip..
> > +static ssize_t find_ibft(void)
> > +{
..snip..
> > +}
>
> What is a function (not even an inline one) doing in a .h file?

I was not sure where to put it. This function (find_ibft) is used by the 
setup_[32|64].c and the iscsi_ibft.c code. Randy suggested I put in .c file, 
but I am not sure exactly where? Should I make a new file in called 
libs/iscsi_ibft_helper.c ?

>
..snip..
> > +struct ibft_kobject {
> > +	struct ibft_data *data;
> > +	char name[IBFT_ISCSI_KOBJECT_MAX_LEN];
>
> Why have this,
>
> > +	u8 type;
> > +	struct kobject kobj;
>
> When the kobject itself has an unlimited size name associated with it?

Absolutely no reason at all. It was a evolution vestige of the code that is
not needed anymore. 

>
..snip..
> > +	char name[IBFT_ISCSI_ATTR_MAX_LEN];
>
> Same here, an attribute already has a pointer to a name, no need to have
> another one in the same structure.

Thanks. Will remove it.
>
> > +	struct list_head node;
> > +};
>
> thanks,

Thank you for taking your time to review the code. I will have the new
version out shortly.
>
> greg k-h


