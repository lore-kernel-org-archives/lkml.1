Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbXLERoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbXLERoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXLERn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:43:58 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:45876 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbXLERn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:43:57 -0500
Date: Wed, 5 Dec 2007 13:41:21 -0400
From: Konrad Rzeszutek <konrad@darnok.org>
To: Doug Maxey <dwm@enoyolf.org>
Cc: darnok@68k.org, linux-kernel@vger.kernel.org, pjones@redhat.com,
       konradr@redhat.com, konradr@linux.vnet.ibm.com, greg@kroah.com,
       randy.dunlap@oracle.com, hpa@zytor.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPOST PATCH] Add iSCSI IBFT support (v0.4)
Message-ID: <20071205174121.GA1801@andromeda.dapyr.net>
References: <20071128233422.GD6736@andromeda.dapyr.net> <20071205004418.GH6736@andromeda.dapyr.net> <22081.1196824331@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22081.1196824331@bebe.enoyolf.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 09:12:11PM -0600, Doug Maxey wrote:
> Overall, looks nice.  Good work.

Thank you.
> 
> comments inline below...
> 
.. snip ..
> > +#include <linux/iscsi_ibft.h>
> 
> Is the current include from open-iscsi being duplicated?  If not, why
> not consolidate in one file?

The include files that come from open-iscsi that are in the kernel do
not have the iBFT data structures in them - therefore no duplication.

I think that consolidating is not necessary. Adding in the iSCSI IBFT
structs (and the module's internal structs) are not essential for
the iSCSI module. From this module standpoint, it is not using
anything from the iSCSI kernel module and its friends so why should it
important a module from there?

Lastly it would also mean the setup_[32|64].c file would have
to include a header file from the iSCSI (linux/scsi/iscsi_proto.h) for the
'find_ibft' prototype. That seems excessive for one function prototype.

.. snip ..
> > +static const char *ibft_id_names[] =
> > +	{"reserved", "control", "initiator", "ethernet%d",
> > +	"target%d", "extension%d"};
> 
> closing null arg.
Done.

> 
> > +
> > +/*
> > + * The text attributes names for each of the kobjects.
> > +*/
> > +enum ibft_eth_properties_enum {
> > +	ibft_eth_index,
> > +	ibft_eth_flags,
> > +	ibft_eth_ip_addr,
> > +	ibft_eth_subnet_mask,
> > +	ibft_eth_origin,
> > +	ibft_eth_gateway,
> > +	ibft_eth_primary_dns,
> > +	ibft_eth_secondary_dns,
> > +	ibft_eth_dhcp,
> > +	ibft_eth_vlan,
> > +	ibft_eth_mac,
> > +	/* ibft_eth_pci_bdf - this is replaced by link to the device itself. */
> > +	ibft_eth_hostname};
> 
> I noticed ibft_eth_hostname gets used as the last marker below.
> Wouldn't it be better to have a ibft_eth_count or some such to really
> be the last?  That way if the elements so change, it still marks the
> last element.

It definitly does. The next version of this patch is named 'ibft_eth_end_marker'.

> 
> > +
> > +static const char *ibft_eth_properties[] =
> > +	{"index", "flags", "ip-addr", "subnet-mask", "origin", "gateway",
> > +	"primary-dns", "secondary-dns", "dhcp", "vlan", "mac", "hostname"};
> > +
> 
> null last entry?

Done.
> 
> > +enum ibft_tgt_properties_enum {
> > +	ibft_tgt_index,
> > +	ibft_tgt_flags,
> > +	ibft_tgt_ip_addr,
> > +	ibft_tgt_port,
> > +	ibft_tgt_lun,
> > +	ibft_tgt_chap_type,
> > +	ibft_tgt_nic_assoc,
> > +	ibft_tgt_name,
> > +	ibft_tgt_chap_name,
> > +	ibft_tgt_chap_secret,
> > +	ibft_tgt_rev_chap_name,
> > +	ibft_tgt_rev_chap_secret};

Added in the 'ibft_tgt_end_marker' as well.

> > +
> > +static const char *ibft_tgt_properties[] =
> > +	{"index", "flags", "ip-addr", "port", "lun", "chap-type", "nic-assoc",
> > +	"target-name", "chap-name", "chap-secret", "rev-chap-name",
> > +	"rev-chap-name-secret"};
> 
> ditto
Done.
> 
> > +
> > +enum ibft_initiator_properties_enum {
> > +	ibft_init_index,
> > +	ibft_init_flags,
> > +	ibft_init_isns_server,
> > +	ibft_init_slp_server,
> > +	ibft_init_pri_radius_server,
> > +	ibft_init_sec_radius_server,
> > +	ibft_init_initiator_name};

Added in the 'ibft_init_end_marker'

> > +
> > +static const char *ibft_initiator_properties[] =
> > +	{"index", "flags", "isns-server", "slp-server", "pri-radius-server",
> > +	"sec-radius-server", "initiator-name"};
> > +
> 
> ditto

Done.

.. snip ..
> > +static ssize_t sprintf_ipaddr(char *buf, u8 *ip)
> > +{
> > +	if (ip[0] == 0 && ip[1] == 0 && ip[2] == 0 && ip[3] == 0 &&
> > +	    ip[4] == 0 && ip[5] == 0 && ip[6] == 0 && ip[7] == 0 &&
> > +	    ip[8] == 0 && ip[9] == 0 && ip[10] == 0xff && ip[11] == 0xff) {
> > +		/*
> > +		 * IPV4
> > +		 */
> > +		return sprintf(buf, "%d.%d.%d.%d\n", ip[12],
> > +			ip[13], ip[14], ip[15]);
> > +	} else {
> > +		return 0;
> > +	}
> 
> redundant braces on the else

Done.

.. snip ..
> > +static int ibft_create_kobject(struct ibft_table_header *header,
> > +			       struct ibft_hdr *hdr,
> > +			       struct list_head *list)
> > +{
> > +	int rc = 0;
> > +	struct ibft_kobject *ibft_kobj = NULL;
> > +
> > +	ibft_kobj = kzalloc(sizeof(*ibft_kobj), GFP_KERNEL);
> 
> Is this going to collide with the new kobject semantics?
> Subject: [RFC] New kobject/kset/ktype documentation and example code
> Message-ID: <20071127230252.GB10038@kroah.com>

No. They do have different names. But I re-did this function a bit
to prepare it for the new function 'kobject_init_and_add' and
to handle error unrolling much better (and free at the right moment the
ibft_kobj structure).

.. snip ..
> > diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
> > new file mode 100644
> > index 0000000..420f621
> > --- /dev/null
> > +++ b/include/linux/iscsi_ibft.h
> > @@ -0,0 +1,126 @@
> > +#ifndef ISCSI_IBFT_H
> > +#define ISCSI_IBFT_H
> 
> missing copyright or left. :)

Yikes! Thanks for spotting that.

New version (v0.4.2) coming out shortly.
