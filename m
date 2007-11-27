Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbXK0Dcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbXK0Dcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 22:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbXK0DcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 22:32:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54292 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbXK0DcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 22:32:04 -0500
Date: Mon, 26 Nov 2007 19:31:38 -0800
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071127033138.GB30770@kroah.com>
References: <20071126225642.GA7973@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126225642.GA7973@andromeda.dapyr.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 06:56:42PM -0400, Konrad Rzeszutek wrote:
> +/*
> + *  Routines for reading of the iBFT data in a human readable fashion.
> + */
> +ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
> +				 struct ibft_attribute *attr,
> +				 char *buf)
> +{
> +	struct ibft_initiator *initiator = attr->initiator;
> +	void *ibft_loc = entry->data->hdr;
> +	char *str = buf;
> +
> +	if (!initiator)
> +		return 0;
> +
> +	str += sprintf_ipaddr(str, "isns", initiator->isns_server);
> +	str += sprintf_ipaddr(str, "slp", initiator->slp_server);
> +	str += sprintf_ipaddr(str, "primary_radius_server",
> +		initiator->pri_radius_server);
> +	str += sprintf_ipaddr(str, "secondary_radius_server",
> +		initiator->sec_radius_server);
> +	str += sprintf_string(str, "itname", initiator->initiator_name_len,
> +		(char *)ibft_loc + initiator->initiator_name_off);
> +	str--;
> +
> +	return str-buf;
> +}

sysfs files have ONE VALUE PER FILE, not a whole bunch of different
things in a single file.  Please fix this.


> +
> +ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
> +			   struct ibft_attribute *attr,
> +			   char *buf)
> +{
> +	struct ibft_nic *nic = attr->nic;
> +	void *ibft_loc = entry->data->hdr;
> +	char *str = buf;
> +
> +	if (!nic)
> +		return 0;
> +	/*
> +	 * Assume dhcp if any non-zero portions of its address are set.
> +	 */
> +	if (memcmp(nic->dhcp, nulls, sizeof(nic->dhcp))) {
> +		str += sprintf_ipaddr(str, "dhcp", nic->dhcp);
> +	} else {
> +		str += sprintf_ipaddr(str, "ciaddr", nic->ip_addr);
> +		str += sprintf_ipaddr(str, "giaddr", nic->gateway);
> +		str += sprintf_ipaddr(str, "dnsaddr1", nic->primary_dns);
> +		str += sprintf_ipaddr(str, "dnsaddr2", nic->secondary_dns);
> +	}
> +	if (nic->hostname_len)
> +		str += sprintf_string(str, "hostname", nic->hostname_len,
> +				(char *)ibft_loc + nic->hostname_off);
> +	/* Cut off the comma. */
> +	str--;
> +
> +	return str-buf;
> +}

Same here.

> +ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
> +			      struct ibft_attribute *attr,
> +			      char *buf)
> +{
> +	struct ibft_tgt *tgt = attr->tgt;
> +	void *ibft_loc = entry->data->hdr;
> +	char *str = buf;
> +	int i;
> +
> +	if (!tgt)
> +		return 0;
> +
> +	str += sprintf_ipaddr(str, "siaddr", tgt->ip_addr);
> +	str += sprintf(str, "iport=%d,", tgt->port);
> +	str += sprintf(str, "ilun=");
> +	for (i = 0; i < 8; i++)
> +		str += sprintf(str, "%x", (u8)tgt->lun[i]);
> +	str += sprintf(str, ",");
> +
> +	if (tgt->tgt_name_len)
> +		str += sprintf_string(str, "iname", tgt->tgt_name_len,
> +		(void *)ibft_loc + tgt->tgt_name_off);
> +
> +	if (tgt->chap_name_len)
> +		str += sprintf_string(str, "chapid", tgt->chap_name_len,
> +			(char *)ibft_loc + tgt->chap_name_off);
> +	if (tgt->chap_secret_len)
> +		str += sprintf_string(str, "chappw", tgt->chap_secret_len,
> +			(char *)ibft_loc + tgt->chap_secret_off);
> +	if (tgt->rev_chap_name_len)
> +		str += sprintf_string(str, "ichapid", tgt->rev_chap_name_len,
> +			(char *)ibft_loc + tgt->rev_chap_name_off);
> +	if (tgt->rev_chap_secret_len)
> +		str += sprintf_string(str, "ichappw", tgt->rev_chap_secret_len,
> +			(char *)ibft_loc + tgt->rev_chap_secret_off);
> +
> +	/* Cut off the comma. */
> +	str--;
> +
> +	return str-buf;
> +}

Same here, are we writing a novella or something to userspace?  :)

> +ssize_t ibft_attr_show_disk(struct ibft_kobject *dev,
> +			    struct ibft_attribute *ibft_attr,
> +			    char *buf)
> +{
> +	char *str = buf;
> +
> +	str += sprintf(str, "//ethernet@0,%d:iscsi,", dev->data->index);
> +	str += ibft_attr_show_initiator(dev, ibft_attr, str);
> +	str += sprintf(str, ",");
> +	str += ibft_attr_show_target(dev, ibft_attr, str);
> +	str += sprintf(str, ",");
> +	str += ibft_attr_show_nic(dev, ibft_attr, str);
> +
> +	return str-buf;
> +}

And here, do I need to go on?

> +ssize_t ibft_attr_show_mac(struct ibft_kobject *entry,
> +			   struct ibft_attribute *attr,
> +			   char *buf)
> +{
> +	struct ibft_nic *nic = attr->nic;
> +	int len = 6;
> +
> +	if (!nic)
> +		return 0;
> +
> +	memcpy(buf, attr->nic->mac, len);
> +
> +	return len;
> +}

Is mac a user readable string?  Then perhaps a simple sprintf would work
instead, as I doubt you are including a \n here...

> +/*
> + * The main routine which allows the user to read the IBFT data.
> + */
> +static ssize_t ibft_show_attribute(struct kobject *kobj,
> +				   struct attribute *attr,
> +				   char *buf)
> +{
> +	struct ibft_kobject *dev =
> +		container_of(kobj, struct ibft_kobject, kobj);
> +	struct ibft_attribute *ibft_attr =
> +		container_of(attr, struct ibft_attribute, attr);
> +	ssize_t ret = -EIO;
> +	char *str = buf;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	if (ibft_attr->show)
> +		ret = ibft_attr->show(dev, ibft_attr, str);
> +
> +	return ret;
> +}
> +
> +static struct sysfs_ops ibft_attr_ops = {
> +	.show = ibft_show_attribute,
> +};

I think this whole mess can go away in the new rework Kay and I have
done, please document this whole thing and I'll see what I can do.

> +struct ibft_control {
> +    struct ibft_hdr hdr;
> +    u16 extensions;
> +    u16 initiator_off;
> +    u16 nic0_off;
> +    u16 tgt0_off;
> +    u16 nic1_off;
> +    u16 tgt1_off;
> +} __attribute__((__packed__));

Did we loose tabs for some reason?  I'm guessing your editor is not
showing them properly, nor did you use scripts/checkpatch.pl :(

> +#if defined(CONFIG_ISCSI_IBFT) || defined(CONFIG_ISCSI_IBFT_MODULE)
> +
> +#define IBFT_SIGN "iBFT"
> +#define IBFT_SIGN_LEN 4
> +#define IBFT_START 0x80000 /* 512kB */
> +#define IBFT_END 0x100000 /* 1MB */
> +#define VGA_MEM 0xA0000 /* VGA buffer */
> +#define VGA_SIZE 0x20000 /* 132kB */
> +static ssize_t find_ibft(void)
> +{
> +	unsigned long pos;
> +
> +	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
> +		void *virt;
> +		/* The table can't be inside the VGA BIOS reserved space,
> +		 * so skip that area */
> +		if (pos == VGA_MEM)
> +			pos += VGA_SIZE;
> +		virt = phys_to_virt(pos);
> +		if (memcmp(virt, IBFT_SIGN, IBFT_SIGN_LEN) == 0) {
> +			unsigned long *addr =
> +			    (unsigned long *)phys_to_virt(pos + 4);
> +			unsigned int len = *addr;
> +			/* if the length of the table extends past 1M,
> +			 * the table cannot be valid. */
> +			if (pos + len <= (IBFT_END-1)) {
> +				ibft_phys = (void *)pos;
> +				return len;
> +			}
> +		}
> +	}
> +	return 0;
> +}

What is a function (not even an inline one) doing in a .h file?

> +enum ibft_kobject_type {
> +	kobject_type_chosen,
> +	kobject_type_ethernet,
> +	kobject_type_target,
> +	kobject_type_aliases
> +};
> +struct ibft_kobject {
> +	struct ibft_data *data;
> +	char name[IBFT_ISCSI_KOBJECT_MAX_LEN];

Why have this,

> +	u8 type;
> +	struct kobject kobj;

When the kobject itself has an unlimited size name associated with it?

> +	struct list_head node;
> +};
> +
> +/*
> + * The text attributes, which can be:
> + *  - local-mac-address (many of them)
> + *  - property (many of them)
> + *  - bootpath (one) , iscsi-diskX (many)
> + *
> +*/
> +#define IBFT_ISCSI_ATTR_DISK_NAME "iscsi-disk%d"
> +#define IBFT_ISCSI_ATTR_PROPERTY_NAME "property"
> +#define IBFT_ISCSI_ATTR_BOOTPATH_NAME "bootpath"
> +#define IBFT_ISCSI_ATTR_LOCAL_MAC_ADDRESS_NAME "local-mac-address"
> +#define IBFT_ISCSI_ATTR_MAX_LEN 18
> +
> +struct ibft_attribute {
> +	struct attribute attr;
> +	ssize_t (*show) (struct  ibft_kobject *entry,
> +			 struct ibft_attribute *attr, char *buf);
> +	struct ibft_initiator *initiator;
> +	struct ibft_nic *nic;
> +	struct ibft_tgt *tgt;
> +	struct kobject *kobj;
> +	char name[IBFT_ISCSI_ATTR_MAX_LEN];

Same here, an attribute already has a pointer to a name, no need to have
another one in the same structure.

> +	struct list_head node;
> +};


thanks,

greg k-h
