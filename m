Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYGYPk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYGYPk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYGYPkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:40:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:41596 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYGYPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:40:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i/q9g7iwQW9DgNMGliEc/e8BBcg9LS8lW6dud1KnRJqwZ5rgppYO3v156dVzCVuzjr
         tliekAt+sCdPoRoE+f0AFnNFzHdRmTSNL7FAvcOZGhXIL6IyiTm5BKzmrma0pZBHOVQk
         D8F4ZIv29x4PDCfUdyRc5jeTjOBa9EuN+HqhM=
Message-ID: <9e4733910807250840n48c6ae79l27af4f320b5b1df1@mail.gmail.com>
Date: Fri, 25 Jul 2008 11:40:09 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 1/4] of: adapt of_find_i2c_driver() to be usable by SPI also
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org
In-Reply-To: <20080725073311.8485.16226.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
	 <20080725073311.8485.16226.stgit@trillian.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/08, Grant Likely <grant.likely@secretlab.ca> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
>  SPI has a similar problem as I2C in that it needs to determine an
>  appropriate modalias value for each device node.  This patch adapts
>  the of_i2c of_find_i2c_driver() function to be usable by of_spi also.
>
>  Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>  ---
>
>   drivers/of/base.c   |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/of/of_i2c.c |   64 ++-----------------------------------
>   include/linux/of.h  |    1 +
>   3 files changed, 92 insertions(+), 61 deletions(-)
>
>  diff --git a/drivers/of/base.c b/drivers/of/base.c
>  index 23ffb7c..ad8ac1a 100644
>  --- a/drivers/of/base.c
>  +++ b/drivers/of/base.c
>  @@ -385,3 +385,91 @@ struct device_node *of_find_matching_node(struct device_node *from,
>         return np;
>   }
>   EXPORT_SYMBOL(of_find_matching_node);
>  +
>  +/**
>  + * of_modalias_table: Table of explicit compatible ==> modalias mappings
>  + *
>  + * This table allows particulare compatible property values to be mapped
>  + * to modalias strings.  This is useful for busses which do not directly
>  + * understand the OF device tree but are populated based on data contained
>  + * within the device tree.  SPI and I2C are the two current users of this
>  + * table.
>  + *
>  + * In most cases, devices do not need to be listed in this table because
>  + * the modalias value can be derived directly from the compatible table.
>  + * However, if for any reason a value cannot be derived, then this table
>  + * provides a method to override the implicit derivation.
>  + *
>  + * At the moment, a single table is used for all bus types because it is
>  + * assumed that the data size is small and that the compatible values
>  + * should already be distinct enough to differentiate between SPI, I2C
>  + * and other devices.

Maybe add a section recommending to update the alias list in the linux
device driver before adding entries here? This table should be a last
resort. I'm not even sure this table should exist, what would be a
case where we would need to make an entry here instead of fixing the
device driver by adding an alias name?

The list of alias part numbers really belong in the devices drivers,
not some global table that has to always be kept in memory.

>  + */
>  +struct of_modalias_table {
>  +       char *of_device;
>  +       char *modalias;
>  +};
>  +static struct of_modalias_table of_modalias_table[] = {
>  +       /* Empty for now; add entries as needed */
>  +};
>  +
>  +/**
>  + * of_modalias_node - Lookup appropriate modalias for a device node
>  + * @node:      pointer to a device tree node
>  + * @modalias:  Pointer to buffer that modalias value will be copied into
>  + * @len:       Length of modalias value
>  + *
>  + * Based on the value of the compatible property, this routine will determine
>  + * an appropriate modalias value for a particular device tree node.  Three
>  + * separate methods are used to derive a modalias value.
>  + *
>  + * First method is to lookup the compatible value in of_modalias_table.
>  + * Second is to look for a "linux,<modalias>" entry in the compatible list
>  + * and used that for modalias.  Third is to strip off the manufacturer
>  + * prefix from the first compatible entry and use the remainder as modalias

I also think this is a problem. Embedding the name of Linux device
drivers into device firmware makes it almost impossible to rename the
device driver.  Again, what is a case where generic part numbers can't
be listed in the alias section of the linux device driver?

Even eeprom was just fixed to take generic part numbers (at24).

>  + *
>  + * This routine returns 0 on success
>  + */
>  +int of_modalias_node(struct device_node *node, char *modalias, int len)
>  +{
>  +       int i, cplen;
>  +       const char *compatible;
>  +       const char *p;
>  +
>  +       /* 1. search for exception list entry */
>  +       for (i = 0; i < ARRAY_SIZE(of_modalias_table); i++) {
>  +               compatible = of_modalias_table[i].of_device;
>  +               if (!of_device_is_compatible(node, compatible))
>  +                       continue;
>  +               strlcpy(modalias, of_modalias_table[i].modalias, len);
>  +               return 0;
>  +       }
>  +
>  +       compatible = of_get_property(node, "compatible", &cplen);
>  +       if (!compatible)
>  +               return -ENODEV;
>  +
>  +       /* 2. search for linux,<modalias> entry */
>  +       p = compatible;
>  +       while (cplen > 0) {
>  +               if (!strncmp(p, "linux,", 6)) {
>  +                       p += 6;
>  +                       strlcpy(modalias, p, len);
>  +                       return 0;
>  +               }
>  +
>  +               i = strlen(p) + 1;
>  +               p += i;
>  +               cplen -= i;
>  +       }
>  +
>  +       /* 3. take first compatible entry and strip manufacturer */
>  +       p = strchr(compatible, ',');
>  +       if (!p)
>  +               return -ENODEV;
>  +       p++;
>  +       strlcpy(modalias, p, len);
>  +       return 0;
>  +}
>  +EXPORT_SYMBOL_GPL(of_modalias_node);
>  +
>  diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
>  index 344e1b0..6a98dc8 100644
>  --- a/drivers/of/of_i2c.c
>  +++ b/drivers/of/of_i2c.c
>  @@ -16,62 +16,6 @@
>   #include <linux/of_i2c.h>
>   #include <linux/module.h>
>
>  -struct i2c_driver_device {
>  -       char    *of_device;
>  -       char    *i2c_type;
>  -};
>  -
>  -static struct i2c_driver_device i2c_devices[] = {
>  -};
>  -
>  -static int of_find_i2c_driver(struct device_node *node,
>  -                             struct i2c_board_info *info)
>  -{
>  -       int i, cplen;
>  -       const char *compatible;
>  -       const char *p;
>  -
>  -       /* 1. search for exception list entry */
>  -       for (i = 0; i < ARRAY_SIZE(i2c_devices); i++) {
>  -               if (!of_device_is_compatible(node, i2c_devices[i].of_device))
>  -                       continue;
>  -               if (strlcpy(info->type, i2c_devices[i].i2c_type,
>  -                           I2C_NAME_SIZE) >= I2C_NAME_SIZE)
>  -                       return -ENOMEM;
>  -
>  -               return 0;
>  -       }
>  -
>  -       compatible = of_get_property(node, "compatible", &cplen);
>  -       if (!compatible)
>  -               return -ENODEV;
>  -
>  -       /* 2. search for linux,<i2c-type> entry */
>  -       p = compatible;
>  -       while (cplen > 0) {
>  -               if (!strncmp(p, "linux,", 6)) {
>  -                       p += 6;
>  -                       if (strlcpy(info->type, p,
>  -                                   I2C_NAME_SIZE) >= I2C_NAME_SIZE)
>  -                               return -ENOMEM;
>  -                       return 0;
>  -               }
>  -
>  -               i = strlen(p) + 1;
>  -               p += i;
>  -               cplen -= i;
>  -       }
>  -
>  -       /* 3. take fist compatible entry and strip manufacturer */
>  -       p = strchr(compatible, ',');
>  -       if (!p)
>  -               return -ENODEV;
>  -       p++;
>  -       if (strlcpy(info->type, p, I2C_NAME_SIZE) >= I2C_NAME_SIZE)
>  -               return -ENOMEM;
>  -       return 0;
>  -}
>  -
>   void of_register_i2c_devices(struct i2c_adapter *adap,
>                              struct device_node *adap_node)
>   {
>  @@ -83,6 +27,9 @@ void of_register_i2c_devices(struct i2c_adapter *adap,
>                 const u32 *addr;
>                 int len;
>
>  +               if (of_modalias_node(node, info.type, sizeof(info.type)) < 0)
>  +                       continue;
>  +
>                 addr = of_get_property(node, "reg", &len);
>                 if (!addr || len < sizeof(int) || *addr > (1 << 10) - 1) {
>                         printk(KERN_ERR
>  @@ -92,11 +39,6 @@ void of_register_i2c_devices(struct i2c_adapter *adap,
>
>                 info.irq = irq_of_parse_and_map(node, 0);
>
>  -               if (of_find_i2c_driver(node, &info) < 0) {
>  -                       irq_dispose_mapping(info.irq);
>  -                       continue;
>  -               }
>  -
>                 info.addr = *addr;
>
>                 request_module(info.type);
>  diff --git a/include/linux/of.h b/include/linux/of.h
>  index 59a61bd..79886ad 100644
>  --- a/include/linux/of.h
>  +++ b/include/linux/of.h
>  @@ -70,5 +70,6 @@ extern int of_n_addr_cells(struct device_node *np);
>   extern int of_n_size_cells(struct device_node *np);
>   extern const struct of_device_id *of_match_node(
>         const struct of_device_id *matches, const struct device_node *node);
>  +extern int of_modalias_node(struct device_node *node, char *modalias, int len);
>
>   #endif /* _LINUX_OF_H */
>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Jon Smirl
jonsmirl@gmail.com
