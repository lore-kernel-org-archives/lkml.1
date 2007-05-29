Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbXE2PiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbXE2PiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 11:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXE2PiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 11:38:10 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:28548 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbXE2PiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 11:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tz54Qxcq/RmsSFBXTI5kJ0F5WB+HZ7QGJbNN6FYlkL83kXH+ixADOEIsa/FkyUKEF+iqbSkU/gE8QYA7/rRknjEr73isPyJev7YvJZ+F2c2V2kXhY1qMhLLDlDdahcIWuwsIp9eaPVk5RXffzzEJ45Pft0peS42E8GNeg/MzXUw=
Message-ID: <43e72e890705290838o50fd0897re3f8fc7547b3758e@mail.gmail.com>
Date: Tue, 29 May 2007 11:38:05 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>, developers@islsm.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] use list_for_each_entry() for iteration in Prism 54 driver
In-Reply-To: <20070527103951.GK31790@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070525125630.GE31790@traven> <20070525130444.GG31790@traven>
	 <20070527103951.GK31790@traven>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/07, Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:
> El Fri, May 25, 2007 at 03:04:44PM +0200 Matthias Kaehlcke ha dit:
>
> > Use list_for_each() in the Prism54 driver to iterate over the MAC list
>
> In response to a similar patch Christoph Hellwig suggests the use of
> list_for_each_entry() instead of list_for_each(). Here is a evolution
> of the patch that takes into account Christophs' suggestion
>
> --
>
> Prism54 driver: Use list_for_each_entry() instead of manual iteration
> and substitute a list_for_each_safe() loop with
> list_for_each_entry_safe()
>
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Singed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

Looks good,

  Luis

> --
>
> diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
> index 283be4a..585f599 100644
> --- a/drivers/net/wireless/prism54/isl_ioctl.c
> +++ b/drivers/net/wireless/prism54/isl_ioctl.c
> @@ -1853,7 +1853,6 @@ prism54_del_mac(struct net_device *ndev, struct iw_request_info *info,
>         islpci_private *priv = netdev_priv(ndev);
>         struct islpci_acl *acl = &priv->acl;
>         struct mac_entry *entry;
> -       struct list_head *ptr;
>         struct sockaddr *addr = (struct sockaddr *) extra;
>
>         if (addr->sa_family != ARPHRD_ETHER)
> @@ -1861,11 +1860,9 @@ prism54_del_mac(struct net_device *ndev, struct iw_request_info *info,
>
>         if (down_interruptible(&acl->sem))
>                 return -ERESTARTSYS;
> -       for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
> -               entry = list_entry(ptr, struct mac_entry, _list);
> -
> +       list_for_each_entry(entry, &acl->mac_list, _list) {
>                 if (memcmp(entry->addr, addr->sa_data, ETH_ALEN) == 0) {
> -                       list_del(ptr);
> +                       list_del(&entry->_list);
>                         acl->size--;
>                         kfree(entry);
>                         up(&acl->sem);
> @@ -1883,7 +1880,6 @@ prism54_get_mac(struct net_device *ndev, struct iw_request_info *info,
>         islpci_private *priv = netdev_priv(ndev);
>         struct islpci_acl *acl = &priv->acl;
>         struct mac_entry *entry;
> -       struct list_head *ptr;
>         struct sockaddr *dst = (struct sockaddr *) extra;
>
>         dwrq->length = 0;
> @@ -1891,9 +1887,7 @@ prism54_get_mac(struct net_device *ndev, struct iw_request_info *info,
>         if (down_interruptible(&acl->sem))
>                 return -ERESTARTSYS;
>
> -       for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
> -               entry = list_entry(ptr, struct mac_entry, _list);
> -
> +       list_for_each_entry(entry, &acl->mac_list, _list) {
>                 memcpy(dst->sa_data, entry->addr, ETH_ALEN);
>                 dst->sa_family = ARPHRD_ETHER;
>                 dwrq->length++;
> @@ -1960,7 +1954,6 @@ prism54_get_policy(struct net_device *ndev, struct iw_request_info *info,
>  static int
>  prism54_mac_accept(struct islpci_acl *acl, char *mac)
>  {
> -       struct list_head *ptr;
>         struct mac_entry *entry;
>         int res = 0;
>
> @@ -1972,8 +1965,7 @@ prism54_mac_accept(struct islpci_acl *acl, char *mac)
>                 return 1;
>         }
>
> -       for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
> -               entry = list_entry(ptr, struct mac_entry, _list);
> +       list_for_each_entry(entry, &acl->mac_list, _list) {
>                 if (memcmp(entry->addr, mac, ETH_ALEN) == 0) {
>                         res = 1;
>                         break;
> @@ -2216,11 +2208,9 @@ prism54_wpa_bss_ie_init(islpci_private *priv)
>  void
>  prism54_wpa_bss_ie_clean(islpci_private *priv)
>  {
> -       struct list_head *ptr, *n;
> +       struct islpci_bss_wpa_ie *bss, *n;
>
> -       list_for_each_safe(ptr, n, &priv->bss_wpa_list) {
> -               struct islpci_bss_wpa_ie *bss;
> -               bss = list_entry(ptr, struct islpci_bss_wpa_ie, list);
> +       list_for_each_entry_safe(bss, n, &priv->bss_wpa_list, list) {
>                 kfree(bss);
>         }
>  }
>
> --
> Matthias Kaehlcke
> Linux Application Developer
> Barcelona
>
>     I am incapable of conceiving infinity, and yet I do not accept finity
>                           (Simone de Beauvoir)
>                                                                  .''`.
>     using free software / Debian GNU/Linux | http://debian.org  : :'  :
>                                                                 `. `'`
> gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
