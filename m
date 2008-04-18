Return-Path: <linux-kernel-owner+w=401wt.eu-S1762554AbYDRVDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554AbYDRVDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbYDRUwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:52:44 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:21694 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760926AbYDRUwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:00 -0400
Message-Id: <20080418205051.486129321@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:16 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 21/53] PNP: use dev_printk when possible
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

Index: work8/drivers/pnp/isapnp/core.c
===================================================================
--- work8.orig/drivers/pnp/isapnp/core.c	2008-04-10 13:28:45.000000000 -0600
+++ work8/drivers/pnp/isapnp/core.c	2008-04-10 13:35:11.000000000 -0600
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
@@ -1114,13 +1111,13 @@
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
Index: work8/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work8.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-10 13:28:45.000000000 -0600
+++ work8/drivers/pnp/pnpacpi/rsparser.c	2008-04-10 13:35:11.000000000 -0600
@@ -108,7 +108,7 @@
 		p = p ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
 
 		if (triggering != t || polarity != p) {
-			pnp_warn("IRQ %d override to %s, %s",
+			dev_warn(&dev->dev, "IRQ %d override to %s, %s\n",
 				gsi, t ? "edge":"level", p ? "low":"high");
 			triggering = t;
 			polarity = p;
@@ -261,7 +261,7 @@
 
 	status = acpi_resource_to_address64(res, p);
 	if (!ACPI_SUCCESS(status)) {
-		pnp_warn("PnPACPI: failed to convert resource type %d",
+		dev_warn(&dev->dev, "failed to convert resource type %d\n",
 			 res->type);
 		return;
 	}
@@ -395,7 +395,8 @@
 		break;
 
 	default:
-		pnp_warn("PnPACPI: unknown resource type %d", res->type);
+		dev_warn(&dev->dev, "unknown resource type %d in _CRS\n",
+			 res->type);
 		return AE_ERROR;
 	}
 
@@ -661,7 +662,8 @@
 	case ACPI_RESOURCE_TYPE_END_DEPENDENT:
 		/*only one EndDependentFn is allowed */
 		if (!parse_data->option_independent) {
-			pnp_warn("PnPACPI: more than one EndDependentFn");
+			dev_warn(&dev->dev, "more than one EndDependentFn "
+				 "in _PRS\n");
 			return AE_ERROR;
 		}
 		parse_data->option = parse_data->option_independent;
@@ -710,7 +712,8 @@
 		break;
 
 	default:
-		pnp_warn("PnPACPI: unknown resource type %d", res->type);
+		dev_warn(&dev->dev, "unknown resource type %d in _PRS\n",
+			 res->type);
 		return AE_ERROR;
 	}
 
@@ -790,7 +793,7 @@
 	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
 				     pnpacpi_count_resources, &res_cnt);
 	if (ACPI_FAILURE(status)) {
-		pnp_err("Evaluate _CRS failed");
+		dev_err(&dev->dev, "can't evaluate _CRS\n");
 		return -EINVAL;
 	}
 	if (!res_cnt)
@@ -805,7 +808,7 @@
 				     pnpacpi_type_resources, &resource);
 	if (ACPI_FAILURE(status)) {
 		kfree(buffer->pointer);
-		pnp_err("Evaluate _CRS failed");
+		dev_err(&dev->dev, "can't evaluate _CRS\n");
 		return -EINVAL;
 	}
 	/* resource will pointer the end resource now */
@@ -1022,7 +1025,8 @@
 		case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
 		case ACPI_RESOURCE_TYPE_GENERIC_REGISTER:
 		default:	/* other type */
-			pnp_warn("unknown resource type %d", resource->type);
+			dev_warn(&dev->dev, "can't encode unknown resource "
+				 "type %d\n", resource->type);
 			return -EINVAL;
 		}
 		resource++;
Index: work8/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work8.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-10 13:28:45.000000000 -0600
+++ work8/drivers/pnp/pnpbios/rsparser.c	2008-04-10 13:35:11.000000000 -0600
@@ -239,9 +239,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag 0x%x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -252,8 +251,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }
@@ -460,8 +458,8 @@
 			if (len != 0)
 				goto len_err;
 			if (option_independent == option)
-				printk(KERN_WARNING
-				       "PnPBIOS: Missing SMALL_TAG_STARTDEP tag\n");
+				dev_warn(&dev->dev, "missing "
+					 "SMALL_TAG_STARTDEP tag\n");
 			option = option_independent;
 			break;
 
@@ -470,9 +468,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag 0x%x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -483,8 +480,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }
@@ -542,9 +538,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag 0x%x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -555,8 +550,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }
@@ -736,9 +730,8 @@
 
 		default:	/* an unkown tag */
 len_err:
-			printk(KERN_ERR
-			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
-			       tag, len);
+			dev_err(&dev->dev, "unknown tag 0x%x length %d\n",
+				tag, len);
 			break;
 		}
 
@@ -749,8 +742,7 @@
 			p += len + 1;
 	}
 
-	printk(KERN_ERR
-	       "PnPBIOS: Resource structure does not contain an end tag.\n");
+	dev_err(&dev->dev, "no end tag in resource structure\n");
 
 	return NULL;
 }

-- 
