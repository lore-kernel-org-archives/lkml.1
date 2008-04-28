Return-Path: <linux-kernel-owner+w=401wt.eu-S967326AbYD1WrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967326AbYD1WrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965005AbYD1WhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:06 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:3049 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965937AbYD1Wgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:53 -0400
Message-Id: <20080428223621.574904688@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:12 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 25/55] PNP: use dev_printk when possible
Content-Disposition: inline; filename=pnp-dev_printk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_printk() when possible for more informative error messages.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/isapnp/core.c      |   38 ++++++++++++++++++--------------------
 drivers/pnp/pnpacpi/rsparser.c |   20 ++++++++++++--------
 drivers/pnp/pnpbios/rsparser.c |   36 ++++++++++++++----------------------
 3 files changed, 44 insertions(+), 50 deletions(-)

Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-28 16:09:22.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-28 16:09:24.000000000 -0600
@@ -737,9 +737,8 @@
 				isapnp_skip_bytes(size);
 			return 1;
 		default:
-			printk(KERN_ERR
-			       "isapnp: unexpected or unknown tag type 0x%x for logical device %i (device %i), ignored\n",
-			       type, dev->number, card->number);
+			dev_err(&dev->dev, "unknown tag %#x (card %i), "
+				"ignored\n", type, card->number);
 		}
 __skip:
 		if (size > 0)
@@ -792,9 +791,8 @@
 				isapnp_skip_bytes(size);
 			return;
 		default:
-			printk(KERN_ERR
-			       "isapnp: unexpected or unknown tag type 0x%x for device %i, ignored\n",
-			       type, card->number);
+			dev_err(&card->dev, "unknown tag %#x, ignored\n",
+			       type);
 		}
 __skip:
 		if (size > 0)
@@ -841,13 +839,6 @@
 		isapnp_wake(csn);
 		isapnp_peek(header, 9);
 		checksum = isapnp_checksum(header);
-#if 0
-		printk(KERN_DEBUG
-		       "vendor: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
-		       header[0], header[1], header[2], header[3], header[4],
-		       header[5], header[6], header[7], header[8]);
-		printk(KERN_DEBUG "checksum = 0x%x\n", checksum);
-#endif
 		eisa_id = header[0] | header[1] << 8 |
 			  header[2] << 16 | header[3] << 24;
 		pnp_eisa_id_to_string(eisa_id, id);
@@ -855,6 +846,13 @@
 		if (!card)
 			continue;
 
+#if 0
+		dev_info(&card->dev,
+		       "vendor: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+		       header[0], header[1], header[2], header[3], header[4],
+		       header[5], header[6], header[7], header[8]);
+		dev_info(&card->dev, "checksum = %#x\n", checksum);
+#endif
 		INIT_LIST_HEAD(&card->devices);
 		card->serial =
 		    (header[7] << 24) | (header[6] << 16) | (header[5] << 8) |
@@ -862,9 +860,8 @@
 		isapnp_checksum_value = 0x00;
 		isapnp_parse_resource_map(card);
 		if (isapnp_checksum_value != 0x00)
-			printk(KERN_ERR
-			       "isapnp: checksum for device %i is not valid (0x%x)\n",
-			       csn, isapnp_checksum_value);
+			dev_err(&card->dev, "invalid checksum %#x\n",
+				isapnp_checksum_value);
 		card->checksum = isapnp_checksum_value;
 
 		pnp_add_card(card);
@@ -1134,13 +1131,13 @@
 	protocol_for_each_card(&isapnp_protocol, card) {
 		cards++;
 		if (isapnp_verbose) {
-			printk(KERN_INFO "isapnp: Card '%s'\n",
-			       card->name[0] ? card->name : "Unknown");
+			dev_info(&card->dev, "card '%s'\n",
+			       card->name[0] ? card->name : "unknown");
 			if (isapnp_verbose < 2)
 				continue;
 			card_for_each_dev(card, dev) {
-				printk(KERN_INFO "isapnp:   Device '%s'\n",
-				       dev->name[0] ? dev->name : "Unknown");
+				dev_info(&card->dev, "device '%s'\n",
+				       dev->name[0] ? dev->name : "unknown");
 			}
 		}
 	}
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:22.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:24.000000000 -0600
@@ -110,7 +110,7 @@
 		p = p ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
 
 		if (triggering != t || polarity != p) {
-			pnp_warn("IRQ %d override to %s, %s",
+			dev_warn(&dev->dev, "IRQ %d override to %s, %s\n",
 				gsi, t ? "edge":"level", p ? "low":"high");
 			triggering = t;
 			polarity = p;
@@ -263,7 +263,7 @@
 
 	status = acpi_resource_to_address64(res, p);
 	if (!ACPI_SUCCESS(status)) {
-		pnp_warn("PnPACPI: failed to convert resource type %d",
+		dev_warn(&dev->dev, "failed to convert resource type %d\n",
 			 res->type);
 		return;
 	}
@@ -397,7 +397,8 @@
 		break;
 
 	default:
-		pnp_warn("PnPACPI: unknown resource type %d", res->type);
+		dev_warn(&dev->dev, "unknown resource type %d in _CRS\n",
+			 res->type);
 		return AE_ERROR;
 	}
 
@@ -674,7 +675,8 @@
 	case ACPI_RESOURCE_TYPE_END_DEPENDENT:
 		/*only one EndDependentFn is allowed */
 		if (!parse_data->option_independent) {
-			pnp_warn("PnPACPI: more than one EndDependentFn");
+			dev_warn(&dev->dev, "more than one EndDependentFn "
+				 "in _PRS\n");
 			return AE_ERROR;
 		}
 		parse_data->option = parse_data->option_independent;
@@ -726,7 +728,8 @@
 		break;
 
 	default:
-		pnp_warn("PnPACPI: unknown resource type %d", res->type);
+		dev_warn(&dev->dev, "unknown resource type %d in _PRS\n",
+			 res->type);
 		return AE_ERROR;
 	}
 
@@ -808,7 +811,7 @@
 	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
 				     pnpacpi_count_resources, &res_cnt);
 	if (ACPI_FAILURE(status)) {
-		pnp_err("Evaluate _CRS failed");
+		dev_err(&dev->dev, "can't evaluate _CRS\n");
 		return -EINVAL;
 	}
 	if (!res_cnt)
@@ -823,7 +826,7 @@
 				     pnpacpi_type_resources, &resource);
 	if (ACPI_FAILURE(status)) {
 		kfree(buffer->pointer);
-		pnp_err("Evaluate _CRS failed");
+		dev_err(&dev->dev, "can't evaluate _CRS\n");
 		return -EINVAL;
 	}
 	/* resource will pointer the end resource now */
@@ -1074,7 +1077,8 @@
 		case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
 		case ACPI_RESOURCE_TYPE_GENERIC_REGISTER:
 		default:	/* other type */
-			pnp_warn("unknown resource type %d", resource->type);
+			dev_warn(&dev->dev, "can't encode unknown resource "
+				 "type %d\n", resource->type);
 			return -EINVAL;
 		}
 		resource++;
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:22.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:24.000000000 -0600
@@ -241,9 +241,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag %#x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -254,8 +253,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }
@@ -471,8 +469,8 @@
 			if (len != 0)
 				goto len_err;
 			if (option_independent == option)
-				printk(KERN_WARNING
-				       "PnPBIOS: Missing SMALL_TAG_STARTDEP tag\n");
+				dev_warn(&dev->dev, "missing "
+					 "SMALL_TAG_STARTDEP tag\n");
 			option = option_independent;
 			dev_dbg(&dev->dev, "end dependent options\n");
 			break;
@@ -482,9 +480,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag %#x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -495,8 +492,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }
@@ -554,9 +550,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag %#x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -567,8 +562,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }
@@ -774,9 +768,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag %#x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -787,8 +780,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }

-- 
