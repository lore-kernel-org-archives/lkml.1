Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbYDAP0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbYDAP0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbYDAPSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:18:48 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:27107 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759330AbYDAPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:18:26 -0400
Message-Id: <20080401151740.419755004@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:58 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 24/37] PNP: use dev_printk when possible
Content-Disposition: inline; filename=pnp-dev_printk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_printk() when possible for more informative error messages.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/isapnp/core.c      |   38 ++++++++++++++++++--------------------
 drivers/pnp/pnpacpi/rsparser.c |   20 ++++++++++++--------
 drivers/pnp/pnpbios/rsparser.c |   36 ++++++++++++++----------------------
 3 files changed, 44 insertions(+), 50 deletions(-)

Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-31 17:10:59.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-31 17:12:17.000000000 -0600
@@ -729,9 +729,8 @@
 				isapnp_skip_bytes(size);
 			return 1;
 		default:
-			printk(KERN_ERR
-			       "isapnp: unexpected or unknown tag type 0x%x for logical device %i (device %i), ignored\n",
-			       type, dev->number, card->number);
+			dev_err(&dev->dev, "unknown tag 0x%x (card %i), "
+				"ignored\n", type, card->number);
 		}
 __skip:
 		if (size > 0)
@@ -784,9 +783,8 @@
 				isapnp_skip_bytes(size);
 			return;
 		default:
-			printk(KERN_ERR
-			       "isapnp: unexpected or unknown tag type 0x%x for device %i, ignored\n",
-			       type, card->number);
+			dev_err(&card->dev, "unknown tag 0x%x, ignored\n",
+			       type);
 		}
 __skip:
 		if (size > 0)
@@ -833,13 +831,6 @@
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
@@ -847,6 +838,13 @@
 		if (!card)
 			continue;
 
+#if 0
+		dev_info(&card->dev,
+		       "vendor: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+		       header[0], header[1], header[2], header[3], header[4],
+		       header[5], header[6], header[7], header[8]);
+		dev_info(&card->dev, "checksum = 0x%x\n", checksum);
+#endif
 		INIT_LIST_HEAD(&card->devices);
 		card->serial =
 		    (header[7] << 24) | (header[6] << 16) | (header[5] << 8) |
@@ -854,9 +852,8 @@
 		isapnp_checksum_value = 0x00;
 		isapnp_parse_resource_map(card);
 		if (isapnp_checksum_value != 0x00)
-			printk(KERN_ERR
-			       "isapnp: checksum for device %i is not valid (0x%x)\n",
-			       csn, isapnp_checksum_value);
+			dev_err(&card->dev, "invalid checksum 0x%x\n",
+				isapnp_checksum_value);
 		card->checksum = isapnp_checksum_value;
 
 		pnp_add_card(card);
@@ -1107,13 +1104,13 @@
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
Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-31 17:10:59.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-31 17:11:07.000000000 -0600
@@ -97,7 +97,7 @@
 		p = p ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
 
 		if (triggering != t || polarity != p) {
-			pnp_warn("IRQ %d override to %s, %s",
+			dev_warn(&dev->dev, "IRQ %d override to %s, %s\n",
 				gsi, t ? "edge":"level", p ? "low":"high");
 			triggering = t;
 			polarity = p;
@@ -161,7 +161,7 @@
 
 	status = acpi_resource_to_address64(res, p);
 	if (!ACPI_SUCCESS(status)) {
-		pnp_warn("PnPACPI: failed to convert resource type %d",
+		dev_warn(&dev->dev, "failed to convert resource type %d\n",
 			 res->type);
 		return;
 	}
@@ -294,7 +294,8 @@
 		break;
 
 	default:
-		pnp_warn("PnPACPI: unknown resource type %d", res->type);
+		dev_warn(&dev->dev, "unknown resource type %d in _CRS\n",
+			 res->type);
 		return AE_ERROR;
 	}
 
@@ -560,7 +561,8 @@
 	case ACPI_RESOURCE_TYPE_END_DEPENDENT:
 		/*only one EndDependentFn is allowed */
 		if (!parse_data->option_independent) {
-			pnp_warn("PnPACPI: more than one EndDependentFn");
+			dev_warn(&dev->dev, "more than one EndDependentFn "
+				 "in _PRS\n");
 			return AE_ERROR;
 		}
 		parse_data->option = parse_data->option_independent;
@@ -609,7 +611,8 @@
 		break;
 
 	default:
-		pnp_warn("PnPACPI: unknown resource type %d", res->type);
+		dev_warn(&dev->dev, "unknown resource type %d in _PRS\n",
+			 res->type);
 		return AE_ERROR;
 	}
 
@@ -689,7 +692,7 @@
 	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
 				     pnpacpi_count_resources, &res_cnt);
 	if (ACPI_FAILURE(status)) {
-		pnp_err("Evaluate _CRS failed");
+		dev_err(&dev->dev, "can't evaluate _CRS\n");
 		return -EINVAL;
 	}
 	if (!res_cnt)
@@ -704,7 +707,7 @@
 				     pnpacpi_type_resources, &resource);
 	if (ACPI_FAILURE(status)) {
 		kfree(buffer->pointer);
-		pnp_err("Evaluate _CRS failed");
+		dev_err(&dev->dev, "can't evaluate _CRS\n");
 		return -EINVAL;
 	}
 	/* resource will pointer the end resource now */
@@ -921,7 +924,8 @@
 		case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
 		case ACPI_RESOURCE_TYPE_GENERIC_REGISTER:
 		default:	/* other type */
-			pnp_warn("unknown resource type %d", resource->type);
+			dev_warn(&dev->dev, "can't encode unknown resource "
+				 "type %d\n", resource->type);
 			return -EINVAL;
 		}
 		resource++;
Index: work7/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/rsparser.c	2008-03-31 17:10:59.000000000 -0600
+++ work7/drivers/pnp/pnpbios/rsparser.c	2008-03-31 17:11:07.000000000 -0600
@@ -161,9 +161,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag 0x%x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -174,8 +173,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }
@@ -382,8 +380,8 @@
 			if (len != 0)
 				goto len_err;
 			if (option_independent == option)
-				printk(KERN_WARNING
-				       "PnPBIOS: Missing SMALL_TAG_STARTDEP tag\n");
+				dev_warn(&dev->dev, "missing "
+					 "SMALL_TAG_STARTDEP tag\n");
 			option = option_independent;
 			break;
 
@@ -392,9 +390,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag 0x%x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -405,8 +402,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }
@@ -464,9 +460,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag 0x%x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -477,8 +472,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }
@@ -658,9 +652,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag 0x%x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -671,8 +664,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }

-- 
