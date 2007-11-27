Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbXK0FJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbXK0FJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbXK0FJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:09:38 -0500
Received: from bebe.enoyolf.org ([24.173.215.190]:34031 "EHLO bebe.enoyolf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbXK0FJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:09:37 -0500
X-Greylist: delayed 3348 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2007 00:09:37 EST
X-Mailer: exmh enoyolf.org version 2.7.2.1 01/17/2005 with nmh-1.1
In-reply-to: <20071127033138.GB30770@kroah.com> 
References: <20071126225642.GA7973@andromeda.dapyr.net>  <20071127033138.GB30770@kroah.com> 
To: Greg KH <greg@kroah.com>
cc: Konrad Rzeszutek <konrad@darnok.org>, linux-kernel@vger.kernel.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, hpa@zytor.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3) 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 26 Nov 2007 22:12:53 -0600
Message-ID: <11870.1196136773@bebe.enoyolf.org>
From: Doug Maxey <dwm@enoyolf.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 26 Nov 2007 19:31:38 PST, Greg KH wrote:
> On Mon, Nov 26, 2007 at 06:56:42PM -0400, Konrad Rzeszutek wrote:
> > +/*
> > + *  Routines for reading of the iBFT data in a human readable fashion.
> > + */
> > +ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
> > +				 struct ibft_attribute *attr,
> > +				 char *buf)
> > +{
> > +	struct ibft_initiator *initiator = attr->initiator;
> > +	void *ibft_loc = entry->data->hdr;
> > +	char *str = buf;
> > +
> > +	if (!initiator)
> > +		return 0;
> > +
> > +	str += sprintf_ipaddr(str, "isns", initiator->isns_server);
> > +	str += sprintf_ipaddr(str, "slp", initiator->slp_server);
> > +	str += sprintf_ipaddr(str, "primary_radius_server",
> > +		initiator->pri_radius_server);
> > +	str += sprintf_ipaddr(str, "secondary_radius_server",
> > +		initiator->sec_radius_server);
> > +	str += sprintf_string(str, "itname", initiator->initiator_name_len,
> > +		(char *)ibft_loc + initiator->initiator_name_off);
> > +	str--;
> > +
> > +	return str-buf;
> > +}
> 
> sysfs files have ONE VALUE PER FILE, not a whole bunch of different
> things in a single file.  Please fix this.

The subparameters _are_ actually part of a single value, that value being 
associated with the initiator instance.

Konrad is trying to implement a "work-alike" for what open firmware does.
open-iscsi already has the ability to extract the same format 
bits from real OFW.

See open-iscsi.git/utils/fwparam_ppc.

> 
> 
> > +
> > +ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
> > +			   struct ibft_attribute *attr,
> > +			   char *buf)
> > +{
> > +	struct ibft_nic *nic = attr->nic;
> > +	void *ibft_loc = entry->data->hdr;
> > +	char *str = buf;
> > +
> > +	if (!nic)
> > +		return 0;
> > +	/*
> > +	 * Assume dhcp if any non-zero portions of its address are set.
> > +	 */
> > +	if (memcmp(nic->dhcp, nulls, sizeof(nic->dhcp))) {
> > +		str += sprintf_ipaddr(str, "dhcp", nic->dhcp);
> > +	} else {
> > +		str += sprintf_ipaddr(str, "ciaddr", nic->ip_addr);
> > +		str += sprintf_ipaddr(str, "giaddr", nic->gateway);
> > +		str += sprintf_ipaddr(str, "dnsaddr1", nic->primary_dns);
> > +		str += sprintf_ipaddr(str, "dnsaddr2", nic->secondary_dns);
> > +	}
> > +	if (nic->hostname_len)
> > +		str += sprintf_string(str, "hostname", nic->hostname_len,
> > +				(char *)ibft_loc + nic->hostname_off);
> > +	/* Cut off the comma. */
> > +	str--;
> > +
> > +	return str-buf;
> > +}
> 
> Same here.
> 
> > +ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
> > +			      struct ibft_attribute *attr,
> > +			      char *buf)
> > +{
> > +	struct ibft_tgt *tgt = attr->tgt;
> > +	void *ibft_loc = entry->data->hdr;
> > +	char *str = buf;
> > +	int i;
> > +
> > +	if (!tgt)
> > +		return 0;
> > +
> > +	str += sprintf_ipaddr(str, "siaddr", tgt->ip_addr);
> > +	str += sprintf(str, "iport=%d,", tgt->port);
> > +	str += sprintf(str, "ilun=");
> > +	for (i = 0; i < 8; i++)
> > +		str += sprintf(str, "%x", (u8)tgt->lun[i]);
> > +	str += sprintf(str, ",");
> > +
> > +	if (tgt->tgt_name_len)
> > +		str += sprintf_string(str, "iname", tgt->tgt_name_len,
> > +		(void *)ibft_loc + tgt->tgt_name_off);
> > +
> > +	if (tgt->chap_name_len)
> > +		str += sprintf_string(str, "chapid", tgt->chap_name_len,
> > +			(char *)ibft_loc + tgt->chap_name_off);
> > +	if (tgt->chap_secret_len)
> > +		str += sprintf_string(str, "chappw", tgt->chap_secret_len,
> > +			(char *)ibft_loc + tgt->chap_secret_off);
> > +	if (tgt->rev_chap_name_len)
> > +		str += sprintf_string(str, "ichapid", tgt->rev_chap_name_len,
> > +			(char *)ibft_loc + tgt->rev_chap_name_off);
> > +	if (tgt->rev_chap_secret_len)
> > +		str += sprintf_string(str, "ichappw", tgt->rev_chap_secret_len,
> > +			(char *)ibft_loc + tgt->rev_chap_secret_off);
> > +
> > +	/* Cut off the comma. */
> > +	str--;
> > +
> > +	return str-buf;
> > +}
> 
> Same here, are we writing a novella or something to userspace?  :)

Yep.  Just like real OFW.

> 
> > +ssize_t ibft_attr_show_disk(struct ibft_kobject *dev,
> > +			    struct ibft_attribute *ibft_attr,
> > +			    char *buf)
> > +{
> > +	char *str = buf;
> > +
> > +	str += sprintf(str, "//ethernet@0,%d:iscsi,", dev->data->index);
> > +	str += ibft_attr_show_initiator(dev, ibft_attr, str);
> > +	str += sprintf(str, ",");
> > +	str += ibft_attr_show_target(dev, ibft_attr, str);
> > +	str += sprintf(str, ",");
> > +	str += ibft_attr_show_nic(dev, ibft_attr, str);
> > +
> > +	return str-buf;
> > +}
> 
> And here, do I need to go on?
> 
> > +ssize_t ibft_attr_show_mac(struct ibft_kobject *entry,
> > +			   struct ibft_attribute *attr,
> > +			   char *buf)
> > +{
> > +	struct ibft_nic *nic = attr->nic;
> > +	int len = 6;
> > +
> > +	if (!nic)
> > +		return 0;
> > +
> > +	memcpy(buf, attr->nic->mac, len);
> > +
> > +	return len;
> > +}
> 
> Is mac a user readable string?  

Nope.  The actual value in OFW is u8[6] in BE.  Again, this all input 
for the fwparam_ppc parser. 

++doug

