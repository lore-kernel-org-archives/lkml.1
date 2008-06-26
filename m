Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbYFZOae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbYFZOae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYFZOaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:30:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:45732 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbYFZOaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:30:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=pOYzIgtU4NH9I82Vyvm8YKnfuwh7Xpvq7EQwaWLruHOkXP+1V242czuAD/UiRazBWE
         DaSMsKhB+L5Lf0gkKAcA3H2uw2ka4I0fiTZSo5ufhSpNV0OBW+FelN0LMBionmwKvwk4
         g/vfQ3G74ZBZNyUhpzgw4pwinCkegbFjItvdM=
Message-ID: <82e4877d0806260730w5fb2640bwa38547153ab42ee4@mail.gmail.com>
Date: Thu, 26 Jun 2008 10:30:22 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: Jie.Yang@Atheros.com
Subject: Re: [PATCH 2.6.25.3 5/5] atl1e: Atheros L1E Gigabit Ethernet driver
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jie Yang <Jie.Yang <at> Atheros.com> writes:


> +static int atl1e_get_eeprom_len(struct net_device *netdev)
> +{
> +       struct atl1e_adapter *adapter = netdev_priv(netdev);
> +
> +       if (!check_eeprom_exist(&adapter->hw))
> +               return 512;

Please #define ATL1E_EEPROM_LEN 512 - it is used below too.

> +       else
> +               return 0;
> +}
> +

> +static int atl1e_get_eeprom(struct net_device *netdev,
> +               struct ethtool_eeprom *eeprom, u8 *bytes)
> +{
> +       struct atl1e_adapter *adapter = netdev_priv(netdev);
> +       struct atl1e_hw *hw = &adapter->hw;
> +       u32 *eeprom_buff;
> +       int first_dword, last_dword;
> +       int ret_val = 0;
> +       int i;
> +
> +       if (eeprom->len == 0)
> +               return -EINVAL;
> +
> +       if (check_eeprom_exist(hw))
> +               return -EINVAL;
> +
> +       eeprom->magic = hw->vendor_id | (hw->device_id << 16);
> +
> +       first_dword = eeprom->offset >> 2;
> +       last_dword = (eeprom->offset + eeprom->len - 1) >> 2;
> +
> +       eeprom_buff = kmalloc(sizeof(u32) *
> +                       (last_dword - first_dword + 1), GFP_KERNEL);
> +       if (eeprom_buff == NULL)
> +               return -ENOMEM;
> +
> +       for (i = first_dword; i < last_dword; i++) {
> +               if (!read_eeprom(hw, i * 4, &(eeprom_buff[i-first_dword])))
> +                       return -EIO;

eeprom_buff is leaked here if read_eeprom fails.

> +       }
> +
> +       memcpy(bytes, (u8 *)eeprom_buff + (eeprom->offset & 3),
> +                       eeprom->len);
> +       kfree(eeprom_buff);
> +
> +       return ret_val;
> +}
> +

> +static int atl1e_set_eeprom(struct net_device *netdev,
> +               struct ethtool_eeprom *eeprom, u8 *bytes)
> +{
> +       struct atl1e_adapter *adapter = netdev_priv(netdev);
> +       struct atl1e_hw *hw = &adapter->hw;
> +       u32 *eeprom_buff;
> +       u32 *ptr;
> +       int max_len, first_dword, last_dword, ret_val = 0;
> +       int i;
> +
> +       if (eeprom->len == 0)
> +               return -EOPNOTSUPP;
> +
> +       if (eeprom->magic != (hw->vendor_id | (hw->device_id << 16)))
> +               return -EFAULT;

This should probably be -EINVAL?

> +
> +       max_len = 512;

Better to replace with a #define as mentioned above.

> +
> +       first_dword = eeprom->offset >> 2;
> +       last_dword = (eeprom->offset + eeprom->len - 1) >> 2;
> +       eeprom_buff = kmalloc(max_len, GFP_KERNEL);
> +       if (!eeprom_buff)
> +               return -ENOMEM;
> +
> +       ptr = (u32 *)eeprom_buff;
> +
> +       if (eeprom->offset & 3) {
> +               /* need read/modify/write of first changed EEPROM word */
> +               /* only the second byte of the word is being modified */
> +               if (!read_eeprom(hw, first_dword * 4, &(eeprom_buff[0])))
> +                       return -EIO;

eeprom_buff is leaked again if read_eeprom() fails.

> +               ptr++;
> +       }
> +       if (((eeprom->offset + eeprom->len) & 3)) {
> +               /* need read/modify/write of last changed EEPROM word */
> +               /* only the first byte of the word is being modified */
> +
> +               if (!read_eeprom(hw, last_dword * 4,
> +                               &(eeprom_buff[last_dword - first_dword])))
> +                       return -EIO;
eeprom_buff is leaked again if read_eeprom() fails.

> +       }
> +
> +       /* Device's eeprom is always little-endian, word addressable */
> +       memcpy(ptr, bytes, eeprom->len);
> +
> +       for (i = 0; i < last_dword - first_dword + 1; i++) {
> +               if (!write_eeprom(hw, ((first_dword + i) * 4), eeprom_buff[i]))
> +                       return -EIO;
eeprom_buff is leaked again if read_eeprom() fails.

> +       }
> +
> +       kfree(eeprom_buff);
> +       return ret_val;
> +}
> +
