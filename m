Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464Ab0ADQMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0ADQMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235Ab0ADQL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:11:57 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:24604 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0ADQLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:11:55 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Joe Perches <joe@perches.com>,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: ISS StorageDev <iss_storagedev@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 4 Jan 2010 16:11:46 +0000
Subject: RE: [PATCH 1/2] drivers/block/cciss: Convert printk(KERN_<level> to
 pr_<level>(
Thread-Topic: [PATCH 1/2] drivers/block/cciss: Convert printk(KERN_<level>
 to pr_<level>(
Thread-Index: AcqBJcI+b0BJxgnJRnC1BTfptIU9sQMMseiw
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77886995B7E01F@GVW0547EXC.americas.hpqcorp.net>
References: <cover.1261279381.git.joe@perches.com>
 <74d1fa188df7f9595339c27f3cbd35ff98d6af0a.1261279381.git.joe@perches.com>
In-Reply-To: <74d1fa188df7f9595339c27f3cbd35ff98d6af0a.1261279381.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Saturday, December 19, 2009 9:37 PM
> To: Stephen M. Cameron; Miller, Mike (OS Dev)
> Cc: ISS StorageDev; linux-kernel@vger.kernel.org
> Subject: [PATCH 1/2] drivers/block/cciss: Convert
> printk(KERN_<level> to pr_<level>(
>
> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt Remove
> leading "cciss: " from fmts Coalesce long format strings Trim
> format trailing spaces Some strings that were "cciss%d:
> errmsg" are now "cciss: %d: errmsg"
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
>  drivers/block/cciss.c      |  283
> ++++++++++++++++++--------------------------
>  drivers/block/cciss_scsi.c |  145 +++++++++--------------
>  2 files changed, 174 insertions(+), 254 deletions(-)
>
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 873e594..14f0e06 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -20,6 +20,8 @@
>   *
>   */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
>  #include <linux/types.h>
> @@ -1903,7 +1905,7 @@ static void cciss_update_drive_info(int
> ctlr, int drv_index, int first_time,
>        * (unless it's the first disk (for the controller node).
>        */
>       if (h->drv[drv_index]->raid_level != -1 && drv_index != 0) {
> -             printk(KERN_WARNING "disk %d has changed.\n",
> drv_index);
> +             pr_warning("disk %d has changed.\n", drv_index);
>               spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
>               h->drv[drv_index]->busy_configuring = 1;
>               spin_unlock_irqrestore(CCISS_LOCK(h->ctlr),
> flags); @@ -1956,8 +1958,8 @@ static void
> cciss_update_drive_info(int ctlr, int drv_index, int first_time,
>               if (cciss_add_disk(h, disk, drv_index) != 0) {
>                       cciss_free_gendisk(h, drv_index);
>                       cciss_free_drive_info(h, drv_index);
> -                     printk(KERN_WARNING "cciss:%d could not update "
> -                             "disk %d\n", h->ctlr, drv_index);
> +                     pr_warning("%d could not update disk %d\n",
> +                                h->ctlr, drv_index);
>                       --h->num_luns;
>               }
>       }
> @@ -1967,7 +1969,7 @@ freeret:
>       kfree(drvinfo);
>       return;
>  mem_msg:
> -     printk(KERN_ERR "cciss: out of memory\n");
> +     pr_err("out of memory\n");
>       goto freeret;
>  }
>
> @@ -2059,9 +2061,8 @@ static int
> cciss_add_gendisk(ctlr_info_t *h, unsigned char lunid[],
>               h->gendisk[drv_index] =
>                       alloc_disk(1 << NWD_SHIFT);
>               if (!h->gendisk[drv_index]) {
> -                     printk(KERN_ERR "cciss%d: could not "
> -                             "allocate a new disk %d\n",
> -                             h->ctlr, drv_index);
> +                     pr_err("%d: could not allocate a new disk %d\n",
> +                            h->ctlr, drv_index);
>                       goto err_free_drive_info;
>               }
>       }
> @@ -2112,8 +2113,7 @@ static void
> cciss_add_controller_node(ctlr_info_t *h)
>       cciss_free_gendisk(h, drv_index);
>       cciss_free_drive_info(h, drv_index);
>  error:
> -     printk(KERN_WARNING "cciss%d: could not "
> -             "add disk 0.\n", h->ctlr);
> +     pr_warning("%d: could not add disk 0.\n", h->ctlr);
>       return;
>  }
>
> @@ -2162,8 +2162,7 @@ static int
> rebuild_lun_table(ctlr_info_t *h, int first_time,
>       if (return_code == IO_OK)
>               listlength = be32_to_cpu(*(__be32 *)
> ld_buff->LUNListLength);
>       else {  /* reading number of logical volumes failed */
> -             printk(KERN_WARNING "cciss: report logical volume"
> -                    " command failed\n");
> +             pr_warning("report logical volume command failed\n");
>               listlength = 0;
>               goto freeret;
>       }
> @@ -2171,9 +2170,7 @@ static int
> rebuild_lun_table(ctlr_info_t *h, int first_time,
>       num_luns = listlength / 8;      /* 8 bytes per entry */
>       if (num_luns > CISS_MAX_LUN) {
>               num_luns = CISS_MAX_LUN;
> -             printk(KERN_WARNING "cciss: more luns configured"
> -                    " on controller than can be handled by"
> -                    " this driver.\n");
> +             pr_warning("more luns configured on controller
> than can be handled by
> +this driver.\n");
>       }
>
>       if (num_luns == 0)
> @@ -2256,7 +2253,7 @@ freeret:
>        */
>       return -1;
>  mem_msg:
> -     printk(KERN_ERR "cciss: out of memory\n");
> +     pr_err("out of memory\n");
>       h->busy_configuring = 0;
>       goto freeret;
>  }
> @@ -2464,8 +2461,7 @@ static int fill_cmd(CommandList_struct
> *c, __u8 cmd, int ctlr, void *buff,
>                       c->Request.Timeout = 0;
>                       break;
>               default:
> -                     printk(KERN_WARNING
> -                            "cciss%d:  Unknown Command
> 0x%c\n", ctlr, cmd);
> +                     pr_warning("%d: Unknown Command
> 0x%c\n", ctlr, cmd);
>                       return IO_ERROR;
>               }
>       } else if (cmd_type == TYPE_MSG) {
> @@ -2497,13 +2493,11 @@ static int
> fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff,
>                       c->Request.CDB[0] = cmd;
>                       break;
>               default:
> -                     printk(KERN_WARNING
> -                            "cciss%d: unknown message type
> %d\n", ctlr, cmd);
> +                     pr_warning("%d: unknown message type
> %d\n", ctlr, cmd);
>                       return IO_ERROR;
>               }
>       } else {
> -             printk(KERN_WARNING
> -                    "cciss%d: unknown command type %d\n",
> ctlr, cmd_type);
> +             pr_warning("%d: unknown command type %d\n",
> ctlr, cmd_type);
>               return IO_ERROR;
>       }
>       /* Fill in the scatter gather information */ @@
> -2531,16 +2525,14 @@ static int
> check_target_status(ctlr_info_t *h, CommandList_struct *c)
>               default:
>                       if (check_for_unit_attention(h, c))
>                               return IO_NEEDS_RETRY;
> -                     printk(KERN_WARNING "cciss%d: cmd 0x%02x "
> -                             "check condition, sense key = 0x%02x\n",
> -                             h->ctlr, c->Request.CDB[0],
> -                             c->err_info->SenseInfo[2]);
> +                     pr_warning("%d: cmd 0x%02x check
> condition, sense key = 0x%02x\n",
> +                                h->ctlr, c->Request.CDB[0],
> +                                c->err_info->SenseInfo[2]);
>               }
>               break;
>       default:
> -             printk(KERN_WARNING "cciss%d: cmd 0x%02x"
> -                     "scsi status = 0x%02x\n", h->ctlr,
> -                     c->Request.CDB[0], c->err_info->ScsiStatus);
> +             pr_warning("%d: cmd 0x%02xscsi status = 0x%02x\n",
> +                        h->ctlr, c->Request.CDB[0],
> c->err_info->ScsiStatus);
>               break;
>       }
>       return IO_ERROR;
> @@ -2562,44 +2554,42 @@ static int
> process_sendcmd_error(ctlr_info_t *h, CommandList_struct *c)
>               /* expected for inquiry and report lun commands */
>               break;
>       case CMD_INVALID:
> -             printk(KERN_WARNING "cciss: cmd 0x%02x is "
> -                    "reported invalid\n", c->Request.CDB[0]);
> +             pr_warning("cmd 0x%02x is reported invalid\n",
> +                        c->Request.CDB[0]);
>               return_status = IO_ERROR;
>               break;
>       case CMD_PROTOCOL_ERR:
> -             printk(KERN_WARNING "cciss: cmd 0x%02x has "
> -                    "protocol error \n", c->Request.CDB[0]);
> +             pr_warning("cmd 0x%02x has protocol error\n",
> +                        c->Request.CDB[0]);
>               return_status = IO_ERROR;
>               break;
>       case CMD_HARDWARE_ERR:
> -             printk(KERN_WARNING "cciss: cmd 0x%02x had "
> -                    " hardware error\n", c->Request.CDB[0]);
> +             pr_warning("cmd 0x%02x had hardware error\n",
> +                        c->Request.CDB[0]);
>               return_status = IO_ERROR;
>               break;
>       case CMD_CONNECTION_LOST:
> -             printk(KERN_WARNING "cciss: cmd 0x%02x had "
> -                    "connection lost\n", c->Request.CDB[0]);
> +             pr_warning("cmd 0x%02x had connection lost\n",
> +                        c->Request.CDB[0]);
>               return_status = IO_ERROR;
>               break;
>       case CMD_ABORTED:
> -             printk(KERN_WARNING "cciss: cmd 0x%02x was "
> -                    "aborted\n", c->Request.CDB[0]);
> +             pr_warning("cmd 0x%02x was aborted\n",
> c->Request.CDB[0]);
>               return_status = IO_ERROR;
>               break;
>       case CMD_ABORT_FAILED:
> -             printk(KERN_WARNING "cciss: cmd 0x%02x reports "
> -                    "abort failed\n", c->Request.CDB[0]);
> +             pr_warning("cmd 0x%02x reports abort failed\n",
> +                        c->Request.CDB[0]);
>               return_status = IO_ERROR;
>               break;
>       case CMD_UNSOLICITED_ABORT:
> -             printk(KERN_WARNING
> -                    "cciss%d: unsolicited abort 0x%02x\n", h->ctlr,
> -                     c->Request.CDB[0]);
> +             pr_warning("%d: unsolicited abort 0x%02x\n",
> +                        h->ctlr, c->Request.CDB[0]);
>               return_status = IO_NEEDS_RETRY;
>               break;
>       default:
> -             printk(KERN_WARNING "cciss: cmd 0x%02x returned "
> -                    "unknown status %x\n", c->Request.CDB[0],
> +             pr_warning("cmd 0x%02x returned unknown status %x\n",
> +                        c->Request.CDB[0],
>                      c->err_info->CommandStatus);
>               return_status = IO_ERROR;
>       }
> @@ -2632,8 +2622,7 @@ resend_cmd2:
>
>       if (return_status == IO_NEEDS_RETRY &&
>               c->retry_count < MAX_CMD_RETRIES) {
> -             printk(KERN_WARNING "cciss%d: retrying
> 0x%02x\n", h->ctlr,
> -                     c->Request.CDB[0]);
> +             pr_warning("%d: retrying 0x%02x\n", h->ctlr,
> c->Request.CDB[0]);
>               c->retry_count++;
>               /* erase the old error information */
>               memset(c->err_info, 0,
> sizeof(ErrorInfo_struct)); @@ -2687,9 +2676,7 @@ static void
> cciss_geometry_inquiry(int ctlr, int logvol,
>                       sizeof(*inq_buff), 0xC1, scsi3addr, TYPE_CMD);
>       if (return_code == IO_OK) {
>               if (inq_buff->data_byte[8] == 0xFF) {
> -                     printk(KERN_WARNING
> -                            "cciss: reading geometry failed, volume "
> -                            "does not support reading geometry\n");
> +                     pr_warning("reading geometry failed,
> volume does not support reading
> +geometry\n");
>                       drv->heads = 255;
>                       drv->sectors = 32;      // Sectors per track
>                       drv->cylinders = total_size + 1;
> @@ -2712,7 +2699,7 @@ static void cciss_geometry_inquiry(int
> ctlr, int logvol,
>                       drv->cylinders = real_size;
>               }
>       } else {                /* Get geometry failed */
> -             printk(KERN_WARNING "cciss: reading geometry failed\n");
> +             pr_warning("reading geometry failed\n");
>       }
>  }
>
> @@ -2726,7 +2713,7 @@ cciss_read_capacity(int ctlr, int
> logvol, sector_t *total_size,
>
>       buf = kzalloc(sizeof(ReadCapdata_struct), GFP_KERNEL);
>       if (!buf) {
> -             printk(KERN_WARNING "cciss: out of memory\n");
> +             pr_warning("out of memory\n");
>               return;
>       }
>
> @@ -2737,7 +2724,7 @@ cciss_read_capacity(int ctlr, int
> logvol, sector_t *total_size,
>               *total_size = be32_to_cpu(*(__be32 *) buf->total_size);
>               *block_size = be32_to_cpu(*(__be32 *) buf->block_size);
>       } else {                /* read capacity command failed */
> -             printk(KERN_WARNING "cciss: read capacity failed\n");
> +             pr_warning("read capacity failed\n");
>               *total_size = 0;
>               *block_size = BLOCK_SIZE;
>       }
> @@ -2753,7 +2740,7 @@ static void cciss_read_capacity_16(int
> ctlr, int logvol,
>
>       buf = kzalloc(sizeof(ReadCapdata_struct_16), GFP_KERNEL);
>       if (!buf) {
> -             printk(KERN_WARNING "cciss: out of memory\n");
> +             pr_warning("out of memory\n");
>               return;
>       }
>
> @@ -2765,12 +2752,12 @@ static void
> cciss_read_capacity_16(int ctlr, int logvol,
>               *total_size = be64_to_cpu(*(__be64 *) buf->total_size);
>               *block_size = be32_to_cpu(*(__be32 *) buf->block_size);
>       } else {                /* read capacity command failed */
> -             printk(KERN_WARNING "cciss: read capacity failed\n");
> +             pr_warning("read capacity failed\n");
>               *total_size = 0;
>               *block_size = BLOCK_SIZE;
>       }
> -     printk(KERN_INFO "      blocks= %llu block_size= %d\n",
> -            (unsigned long long)*total_size+1, *block_size);
> +     pr_info("      blocks= %llu block_size= %d\n",
> +             (unsigned long long)*total_size+1, *block_size);
>       kfree(buf);
>  }
>
> @@ -2797,7 +2784,7 @@ static int cciss_revalidate(struct
> gendisk *disk)
>
>       inq_buff = kmalloc(sizeof(InquiryData_struct), GFP_KERNEL);
>       if (inq_buff == NULL) {
> -             printk(KERN_WARNING "cciss: out of memory\n");
> +             pr_warning("out of memory\n");
>               return 1;
>       }
>       if (h->cciss_read == CCISS_READ_10) {
> @@ -2841,7 +2828,7 @@ static void start_io(ctlr_info_t *h)
>               c = hlist_entry(h->reqQ.first,
> CommandList_struct, list);
>               /* can't do anything if fifo is full */
>               if ((h->access.fifo_full(h))) {
> -                     printk(KERN_WARNING "cciss: fifo full\n");
> +                     pr_warning("fifo full\n");
>                       break;
>               }
>
> @@ -2908,9 +2895,8 @@ static inline int
> evaluate_target_status(ctlr_info_t *h,
>
>       if (cmd->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION) {
>               if (!blk_pc_request(cmd->rq))
> -                     printk(KERN_WARNING "cciss: cmd %p "
> -                            "has SCSI Status 0x%x\n",
> -                            cmd, cmd->err_info->ScsiStatus);
> +                     pr_warning("cmd %p has SCSI Status 0x%x\n",
> +                                cmd, cmd->err_info->ScsiStatus);
>               return error_value;
>       }
>
> @@ -2927,8 +2913,8 @@ static inline int
> evaluate_target_status(ctlr_info_t *h,
>
>       if (!blk_pc_request(cmd->rq)) { /* Not SG_IO or similar? */
>               if (error_value != 0)
> -                     printk(KERN_WARNING "cciss: cmd %p has
> CHECK CONDITION"
> -                            " sense key = 0x%x\n", cmd, sense_key);
> +                     pr_warning("cmd %p has CHECK CONDITION
> sense key = 0x%x\n",
> +                                cmd, sense_key);
>               return error_value;
>       }
>
> @@ -2968,85 +2954,72 @@ static inline void
> complete_command(ctlr_info_t *h, CommandList_struct *cmd,
>               break;
>       case CMD_DATA_UNDERRUN:
>               if (blk_fs_request(cmd->rq)) {
> -                     printk(KERN_WARNING "cciss: cmd %p has"
> -                            " completed with data underrun "
> -                            "reported\n", cmd);
> +                     pr_warning("cmd %p has completed with
> data underrun reported\n",
> +                                cmd);
>                       cmd->rq->resid_len = cmd->err_info->ResidualCnt;
>               }
>               break;
>       case CMD_DATA_OVERRUN:
>               if (blk_fs_request(cmd->rq))
> -                     printk(KERN_WARNING "cciss: cmd %p has"
> -                            " completed with data overrun "
> -                            "reported\n", cmd);
> +                     pr_warning("cmd %p has"
> +                            " completed with data overrun
> reported\n", cmd);
>               break;
>       case CMD_INVALID:
> -             printk(KERN_WARNING "cciss: cmd %p is "
> -                    "reported invalid\n", cmd);
> +             pr_warning("cmd %p is reported invalid\n", cmd);
>               rq->errors = make_status_bytes(SAM_STAT_GOOD,
>                       cmd->err_info->CommandStatus, DRIVER_OK,
>                       blk_pc_request(cmd->rq) ?
> DID_PASSTHROUGH : DID_ERROR);
>               break;
>       case CMD_PROTOCOL_ERR:
> -             printk(KERN_WARNING "cciss: cmd %p has "
> -                    "protocol error \n", cmd);
> +             pr_warning("cmd %p has protocol error \n", cmd);
>               rq->errors = make_status_bytes(SAM_STAT_GOOD,
>                       cmd->err_info->CommandStatus, DRIVER_OK,
>                       blk_pc_request(cmd->rq) ?
> DID_PASSTHROUGH : DID_ERROR);
>               break;
>       case CMD_HARDWARE_ERR:
> -             printk(KERN_WARNING "cciss: cmd %p had "
> -                    " hardware error\n", cmd);
> +             pr_warning("cmd %p had  hardware error\n", cmd);
>               rq->errors = make_status_bytes(SAM_STAT_GOOD,
>                       cmd->err_info->CommandStatus, DRIVER_OK,
>                       blk_pc_request(cmd->rq) ?
> DID_PASSTHROUGH : DID_ERROR);
>               break;
>       case CMD_CONNECTION_LOST:
> -             printk(KERN_WARNING "cciss: cmd %p had "
> -                    "connection lost\n", cmd);
> +             pr_warning("cmd %p had connection lost\n", cmd);
>               rq->errors = make_status_bytes(SAM_STAT_GOOD,
>                       cmd->err_info->CommandStatus, DRIVER_OK,
>                       blk_pc_request(cmd->rq) ?
> DID_PASSTHROUGH : DID_ERROR);
>               break;
>       case CMD_ABORTED:
> -             printk(KERN_WARNING "cciss: cmd %p was "
> -                    "aborted\n", cmd);
> +             pr_warning("cmd %p was aborted\n", cmd);
>               rq->errors = make_status_bytes(SAM_STAT_GOOD,
>                       cmd->err_info->CommandStatus, DRIVER_OK,
>                       blk_pc_request(cmd->rq) ?
> DID_PASSTHROUGH : DID_ABORT);
>               break;
>       case CMD_ABORT_FAILED:
> -             printk(KERN_WARNING "cciss: cmd %p reports "
> -                    "abort failed\n", cmd);
> +             pr_warning("cmd %p reports abort failed\n", cmd);
>               rq->errors = make_status_bytes(SAM_STAT_GOOD,
>                       cmd->err_info->CommandStatus, DRIVER_OK,
>                       blk_pc_request(cmd->rq) ?
> DID_PASSTHROUGH : DID_ERROR);
>               break;
>       case CMD_UNSOLICITED_ABORT:
> -             printk(KERN_WARNING "cciss%d: unsolicited "
> -                    "abort %p\n", h->ctlr, cmd);
> +             pr_warning("%d: unsolicited abort %p\n", h->ctlr, cmd);
>               if (cmd->retry_count < MAX_CMD_RETRIES) {
>                       retry_cmd = 1;
> -                     printk(KERN_WARNING
> -                            "cciss%d: retrying %p\n", h->ctlr, cmd);
> +                     pr_warning("%d: retrying %p\n", h->ctlr, cmd);
>                       cmd->retry_count++;
>               } else
> -                     printk(KERN_WARNING
> -                            "cciss%d: %p retried too "
> -                            "many times\n", h->ctlr, cmd);
> +                     pr_warning("%d: %p retried too many
> times\n", h->ctlr, cmd);
>               rq->errors = make_status_bytes(SAM_STAT_GOOD,
>                       cmd->err_info->CommandStatus, DRIVER_OK,
>                       blk_pc_request(cmd->rq) ?
> DID_PASSTHROUGH : DID_ABORT);
>               break;
>       case CMD_TIMEOUT:
> -             printk(KERN_WARNING "cciss: cmd %p timedout\n", cmd);
> +             pr_warning("cmd %p timedout\n", cmd);
>               rq->errors = make_status_bytes(SAM_STAT_GOOD,
>                       cmd->err_info->CommandStatus, DRIVER_OK,
>                       blk_pc_request(cmd->rq) ?
> DID_PASSTHROUGH : DID_ERROR);
>               break;
>       default:
> -             printk(KERN_WARNING "cciss: cmd %p returned "
> -                    "unknown status %x\n", cmd,
> +             pr_warning("cmd %p returned unknown status %x\n", cmd,
>                      cmd->err_info->CommandStatus);
>               rq->errors = make_status_bytes(SAM_STAT_GOOD,
>                       cmd->err_info->CommandStatus,
> DRIVER_OK, @@ -3126,7 +3099,7 @@ static void
> do_cciss_request(struct request_queue *q)
>           (rq_data_dir(creq) == READ) ? h->cciss_read :
> h->cciss_write;
>       start_blk = blk_rq_pos(creq);
>  #ifdef CCISS_DEBUG
> -     printk(KERN_DEBUG "ciss: sector =%d nr_sectors=%d\n",
> +     printk(KERN_DEBUG "cciss: sector =%d nr_sectors=%d\n",
>              (int)blk_rq_pos(creq), (int)blk_rq_sectors(creq));
>  #endif                               /* CCISS_DEBUG */
>
> @@ -3237,7 +3210,7 @@ static void do_cciss_request(struct
> request_queue *q)
>               c->Request.CDBLen = creq->cmd_len;
>               memcpy(c->Request.CDB, creq->cmd, BLK_MAX_CDB);
>       } else {
> -             printk(KERN_WARNING "cciss%d: bad request type
> %d\n", h->ctlr, creq->cmd_type);
> +             pr_warning("%d: bad request type %d\n",
> h->ctlr, creq->cmd_type);
>               BUG();
>       }
>
> @@ -3294,8 +3267,7 @@ static irqreturn_t do_cciss_intr(int
> irq, void *dev_id)
>                       if ((a & 0x04)) {
>                               a2 = (a >> 3);
>                               if (a2 >= h->nr_cmds) {
> -                                     printk(KERN_WARNING
> -                                            "cciss:
> controller cciss%d failed, stopping.\n",
> +                                     pr_warning("controller
> cciss%d failed, stopping.\n",
>                                              h->ctlr);
>                                       fail_all_cmds(h->ctlr);
>                                       return IRQ_HANDLED;
> @@ -3466,18 +3438,15 @@ static int
> check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
>
>       switch (c->err_info->SenseInfo[12]) {
>       case STATE_CHANGED:
> -             printk(KERN_WARNING "cciss%d: a state change "
> -                     "detected, command retried\n", h->ctlr);
> +             pr_warning("%d: a state change detected,
> command retried\n",
> +h->ctlr);
>               return 1;
>       break;
>       case LUN_FAILED:
> -             printk(KERN_WARNING "cciss%d: LUN failure "
> -                     "detected, action required\n", h->ctlr);
> +             pr_warning("%d: LUN failure detected, action
> required\n", h->ctlr);
>               return 1;
>       break;
>       case REPORT_LUNS_CHANGED:
> -             printk(KERN_WARNING "cciss%d: report LUN data "
> -                     "changed\n", h->ctlr);
> +             pr_warning("%d: report LUN data changed\n", h->ctlr);
>       /*
>        * Here, we could call add_to_scan_list and wake up the
> scan thread,
>        * except that it's quite likely that we will get more
> than one @@ -3497,18 +3466,15 @@ static int
> check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
>               return 1;
>       break;
>       case POWER_OR_RESET:
> -             printk(KERN_WARNING "cciss%d: a power on "
> -                     "or device reset detected\n", h->ctlr);
> +             pr_warning("%d: a power on or device reset
> detected\n", h->ctlr);
>               return 1;
>       break;
>       case UNIT_ATTENTION_CLEARED:
> -             printk(KERN_WARNING "cciss%d: unit attention "
> -                 "cleared by another initiator\n", h->ctlr);
> +             pr_warning("%d: unit attention cleared by
> another initiator\n",
> +h->ctlr);
>               return 1;
>       break;
>       default:
> -             printk(KERN_WARNING "cciss%d: unknown "
> -                     "unit attention detected\n", h->ctlr);
> +             pr_warning("%d: unknown unit attention
> detected\n", h->ctlr);
>                               return 1;
>       }
>  }
> @@ -3574,8 +3540,7 @@ static int find_PCI_BAR_index(struct
> pci_dev *pdev, unsigned long pci_bar_addr)
>                               offset += 8;
>                               break;
>                       default:        /* reserved in PCI 2.2 */
> -                             printk(KERN_WARNING
> -                                    "Base address is invalid\n");
> +                             pr_warning("Base address is invalid\n");
>                               return -1;
>                               break;
>                       }
> @@ -3616,11 +3581,10 @@ static void __devinit
> cciss_interrupt_mode(ctlr_info_t *c,
>                       return;
>               }
>               if (err > 0) {
> -                     printk(KERN_WARNING "cciss: only %d
> MSI-X vectors "
> -                            "available\n", err);
> +                     pr_warning("only %d MSI-X vectors
> available\n", err);
>                       goto default_int_mode;
>               } else {
> -                     printk(KERN_WARNING "cciss: MSI-X init
> failed %d\n",
> +                     pr_warning("MSI-X init failed %d\n",
>                              err);
>                       goto default_int_mode;
>               }
> @@ -3629,7 +3593,7 @@ static void __devinit
> cciss_interrupt_mode(ctlr_info_t *c,
>               if (!pci_enable_msi(pdev)) {
>                       c->msi_vector = 1;
>               } else {
> -                     printk(KERN_WARNING "cciss: MSI init failed\n");
> +                     pr_warning("MSI init failed\n");
>               }
>       }
>  default_int_mode:
> @@ -3672,21 +3636,19 @@ static int __devinit
> cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>       /* BEFORE trying to enable it */
>       (void)pci_read_config_word(pdev, PCI_COMMAND, &command);
>       if (!(command & 0x02)) {
> -             printk(KERN_WARNING
> -                    "cciss: controller appears to be disabled\n");
> +             pr_warning("controller appears to be disabled\n");
>               return -ENODEV;
>       }
>
>       err = pci_enable_device(pdev);
>       if (err) {
> -             printk(KERN_ERR "cciss: Unable to Enable PCI device\n");
> +             pr_err("Unable to Enable PCI device\n");
>               return err;
>       }
>
>       err = pci_request_regions(pdev, "cciss");
>       if (err) {
> -             printk(KERN_ERR "cciss: Cannot obtain PCI resources, "
> -                    "aborting\n");
> +             pr_err("Cannot obtain PCI resources, aborting\n");
>               return err;
>       }
>
> @@ -3707,7 +3669,7 @@ static int __devinit
> cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>                       break;
>       }
>       if (i == DEVICE_COUNT_RESOURCE) {
> -             printk(KERN_WARNING "cciss: No memory BAR found\n");
> +             pr_warning("No memory BAR found\n");
>               err = -ENODEV;
>               goto err_out_free_res;
>       }
> @@ -3731,7 +3693,7 @@ static int __devinit
> cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>               schedule_timeout(msecs_to_jiffies(100));
> /* wait 100ms */
>       }
>       if (scratchpad != CCISS_FIRMWARE_READY) {
> -             printk(KERN_WARNING "cciss: Board not ready.
> Timed out.\n");
> +             pr_warning("Board not ready.  Timed out.\n");
>               err = -ENODEV;
>               goto err_out_free_res;
>       }
> @@ -3748,7 +3710,7 @@ static int __devinit
> cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>               (unsigned long long)cfg_base_addr_index);
>  #endif                               /* CCISS_DEBUG */
>       if (cfg_base_addr_index == -1) {
> -             printk(KERN_WARNING "cciss: Cannot find
> cfg_base_addr_index\n");
> +             pr_warning("Cannot find cfg_base_addr_index\n");
>               err = -ENODEV;
>               goto err_out_free_res;
>       }
> @@ -3857,8 +3819,7 @@ static int __devinit
> cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>  #endif                               /* CCISS_DEBUG */
>
>       if (!(readl(&(c->cfgtable->TransportActive)) &
> CFGTBL_Trans_Simple)) {
> -             printk(KERN_WARNING "cciss: unable to get board into"
> -                    " simple mode\n");
> +             pr_warning("unable to get board into simple mode\n");
>               err = -ENODEV;
>               goto err_out_free_res;
>       }
> @@ -3891,11 +3852,10 @@ static int alloc_cciss_hba(void)
>                       return i;
>               }
>       }
> -     printk(KERN_WARNING "cciss: This driver supports a maximum"
> -            " of %d controllers.\n", MAX_CTLR);
> +     pr_warning("This driver supports a maximum of %d
> controllers.\n",
> +MAX_CTLR);
>       return -1;
>  Enomem:
> -     printk(KERN_ERR "cciss: out of memory.\n");
> +     pr_err("out of memory.\n");
>       return -1;
>  }
>
> @@ -3984,7 +3944,7 @@ static __devinit int
> cciss_message(struct pci_dev *pdev, unsigned char opcode, u
>       /* we leak the DMA buffer here ... no choice since the
> controller could
>          still complete the command. */
>       if (i == 10) {
> -             printk(KERN_ERR "cciss: controller message
> %02x:%02x timed out\n",
> +             pr_err("controller message %02x:%02x timed out\n",
>                       opcode, type);
>               return -ETIMEDOUT;
>       }
> @@ -3992,12 +3952,12 @@ static __devinit int
> cciss_message(struct pci_dev *pdev, unsigned char opcode, u
>       pci_free_consistent(pdev, cmd_sz, cmd, paddr64);
>
>       if (tag & 2) {
> -             printk(KERN_ERR "cciss: controller message
> %02x:%02x failed\n",
> +             pr_err("controller message %02x:%02x failed\n",
>                       opcode, type);
>               return -EIO;
>       }
>
> -     printk(KERN_INFO "cciss: controller message %02x:%02x
> succeeded\n",
> +     pr_info("controller message %02x:%02x succeeded\n",
>               opcode, type);
>       return 0;
>  }
> @@ -4018,7 +3978,7 @@ static __devinit int
> cciss_reset_msi(struct pci_dev *pdev)
>       if (pos) {
>               pci_read_config_word(pdev,
> msi_control_reg(pos), &control);
>               if (control & PCI_MSI_FLAGS_ENABLE) {
> -                     printk(KERN_INFO "cciss: resetting MSI\n");
> +                     pr_info("resetting MSI\n");
>                       pci_write_config_word(pdev,
> msi_control_reg(pos), control & ~PCI_MSI_FLAGS_ENABLE);
>               }
>       }
> @@ -4027,7 +3987,7 @@ static __devinit int
> cciss_reset_msi(struct pci_dev *pdev)
>       if (pos) {
>               pci_read_config_word(pdev,
> msi_control_reg(pos), &control);
>               if (control & PCI_MSIX_FLAGS_ENABLE) {
> -                     printk(KERN_INFO "cciss: resetting MSI-X\n");
> +                     pr_info("resetting MSI-X\n");
>                       pci_write_config_word(pdev,
> msi_control_reg(pos), control & ~PCI_MSIX_FLAGS_ENABLE);
>               }
>       }
> @@ -4042,7 +4002,7 @@ static __devinit int
> cciss_hard_reset_controller(struct pci_dev *pdev)
>       u16 pmcsr, saved_config_space[32];
>       int i, pos;
>
> -     printk(KERN_INFO "cciss: using PCI PM to reset controller\n");
> +     pr_info("using PCI PM to reset controller\n");
>
>       /* This is very nearly the same thing as
>
> @@ -4064,7 +4024,7 @@ static __devinit int
> cciss_hard_reset_controller(struct pci_dev *pdev)
>
>       pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
>       if (pos == 0) {
> -             printk(KERN_ERR "cciss_reset_controller: PCI PM
> not supported\n");
> +             pr_err("_reset_controller: PCI PM not supported\n");
>               return -ENODEV;
>       }
>
> @@ -4138,7 +4098,7 @@ static int __devinit
> cciss_init_one(struct pci_dev *pdev,
>                       schedule_timeout_uninterruptible(HZ);
>               }
>               if (i == 30) {
> -                     printk(KERN_ERR "cciss: controller
> seems dead\n");
> +                     pr_err("controller seems dead\n");
>                       return -EBUSY;
>               }
>       }
> @@ -4170,7 +4130,7 @@ static int __devinit
> cciss_init_one(struct pci_dev *pdev,
>       else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
>               dac = 0;
>       else {
> -             printk(KERN_ERR "cciss: no suitable DMA available\n");
> +             pr_err("no suitable DMA available\n");
>               goto clean1;
>       }
>
> @@ -4183,9 +4143,8 @@ static int __devinit
> cciss_init_one(struct pci_dev *pdev,
>               hba[i]->major = COMPAQ_CISS_MAJOR + i;
>       rc = register_blkdev(hba[i]->major, hba[i]->devname);
>       if (rc == -EBUSY || rc == -EINVAL) {
> -             printk(KERN_ERR
> -                    "cciss:  Unable to get major number %d for %s "
> -                    "on hba %d\n", hba[i]->major,
> hba[i]->devname, i);
> +             pr_err("Unable to get major number %d for %s on
> hba %d\n",
> +                    hba[i]->major, hba[i]->devname, i);
>               goto clean1;
>       } else {
>               if (i >= MAX_CTLR_ORIG)
> @@ -4196,13 +4155,13 @@ static int __devinit
> cciss_init_one(struct pci_dev *pdev,
>       hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_OFF);
>       if (request_irq(hba[i]->intr[SIMPLE_MODE_INT], do_cciss_intr,
>                       IRQF_DISABLED | IRQF_SHARED,
> hba[i]->devname, hba[i])) {
> -             printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
> +             pr_err("Unable to get irq %d for %s\n",
>                      hba[i]->intr[SIMPLE_MODE_INT], hba[i]->devname);
>               goto clean2;
>       }
>
> -     printk(KERN_INFO "%s: <0x%x> at PCI %s IRQ %d%s using DAC\n",
> -            hba[i]->devname, pdev->device, pci_name(pdev),
> +     pr_info("%s: <0x%x> at PCI %s IRQ %d%s using DAC\n",
> +             hba[i]->devname, pdev->device, pci_name(pdev),
>              hba[i]->intr[SIMPLE_MODE_INT], dac ? "" : " not");
>
>       hba[i]->cmd_pool_bits =
> @@ -4219,7 +4178,7 @@ static int __devinit
> cciss_init_one(struct pci_dev *pdev,
>       if ((hba[i]->cmd_pool_bits == NULL)
>           || (hba[i]->cmd_pool == NULL)
>           || (hba[i]->errinfo_pool == NULL)) {
> -             printk(KERN_ERR "cciss: out of memory");
> +             pr_err("out of memory");
>               goto clean4;
>       }
>
> @@ -4232,8 +4191,7 @@ static int __devinit
> cciss_init_one(struct pci_dev *pdev,
>
> hba[i]->maxsgentries,
>                                                       GFP_KERNEL);
>               if (hba[i]->scatter_list[k] == NULL) {
> -                     printk(KERN_ERR "cciss%d: could not allocate "
> -                             "s/g lists\n", i);
> +                     pr_err("%d: could not allocate s/g lists\n", i);
>                       goto clean4;
>               }
>       }
> @@ -4241,8 +4199,7 @@ static int __devinit
> cciss_init_one(struct pci_dev *pdev,
>                                               hba[i]->nr_cmds,
>                                               GFP_KERNEL);
>       if (!hba[i]->cmd_sg_list) {
> -             printk(KERN_ERR "cciss%d: Cannot get memory for "
> -                     "s/g chaining.\n", i);
> +             pr_err("%d: Cannot get memory for s/g chaining.\n", i);
>               goto clean4;
>       }
>       /* Build up chain blocks for each command */ @@ -4252,8
> +4209,8 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>                                       kmalloc(sizeof(struct
> Cmd_sg_list),
>                                                       GFP_KERNEL);
>                       if (!hba[i]->cmd_sg_list[j]) {
> -                             printk(KERN_ERR "cciss%d:
> Cannot get memory "
> -                                     "for chain block.\n", i);
> +                             pr_err("%d: Cannot get memory
> for chain block.\n",
> +                                    i);
>                               goto clean4;
>                       }
>                       /* Need a block of chainsized s/g
> elements. */ @@ -4262,8 +4219,8 @@ static int __devinit
> cciss_init_one(struct pci_dev *pdev,
>
> sizeof(SGDescriptor_struct)),
>                                               GFP_KERNEL);
>                       if (!hba[i]->cmd_sg_list[j]->sgchain) {
> -                             printk(KERN_ERR "cciss%d:
> Cannot get memory "
> -                                     "for s/g chains\n", i);
> +                             pr_err("%d: Cannot get memory
> for s/g chains\n",
> +                                    i);
>                               goto clean4;
>                       }
>               }
> @@ -4295,7 +4252,7 @@ static int __devinit
> cciss_init_one(struct pci_dev *pdev,
>       /* Get the firmware version */
>       inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
>       if (inq_buff == NULL) {
> -             printk(KERN_ERR "cciss: out of memory\n");
> +             pr_err("out of memory\n");
>               goto clean4;
>       }
>
> @@ -4307,8 +4264,7 @@ static int __devinit
> cciss_init_one(struct pci_dev *pdev,
>               hba[i]->firm_ver[2] = inq_buff->data_byte[34];
>               hba[i]->firm_ver[3] = inq_buff->data_byte[35];
>       } else {         /* send command failed */
> -             printk(KERN_WARNING "cciss: unable to determine
> firmware"
> -                     " version of controller\n");
> +             pr_warning("unable to determine firmware
> version of controller\n");
>       }
>       kfree(inq_buff);
>
> @@ -4373,9 +4329,7 @@ static void cciss_shutdown(struct pci_dev *pdev)
>       h = pci_get_drvdata(pdev);
>       flush_buf = kzalloc(4, GFP_KERNEL);
>       if (!flush_buf) {
> -             printk(KERN_WARNING
> -                     "cciss:%d cache not flushed, out of memory.\n",
> -                     h->ctlr);
> +             pr_warning("%d cache not flushed, out of
> memory.\n", h->ctlr);
>               return;
>       }
>       /* write all data in the battery backed cache to disk
> */ @@ -4384,8 +4338,7 @@ static void cciss_shutdown(struct
> pci_dev *pdev)
>               4, 0, CTLR_LUNID, TYPE_CMD);
>       kfree(flush_buf);
>       if (return_code != IO_OK)
> -             printk(KERN_WARNING "cciss%d: Error flushing cache\n",
> -                     h->ctlr);
> +             pr_warning("%d: Error flushing cache\n", h->ctlr);
>       h->access.set_intr_mask(h, CCISS_INTR_OFF);
>       free_irq(h->intr[2], h);
>  }
> @@ -4396,15 +4349,14 @@ static void __devexit
> cciss_remove_one(struct pci_dev *pdev)
>       int i, j;
>
>       if (pci_get_drvdata(pdev) == NULL) {
> -             printk(KERN_ERR "cciss: Unable to remove device \n");
> +             pr_err("Unable to remove device \n");
>               return;
>       }
>
>       tmp_ptr = pci_get_drvdata(pdev);
>       i = tmp_ptr->ctlr;
>       if (hba[i] == NULL) {
> -             printk(KERN_ERR "cciss: device appears to "
> -                    "already be removed \n");
> +             pr_err("device appears to already be removed\n");
>               return;
>       }
>
> @@ -4497,7 +4449,7 @@ static int __init cciss_init(void)
>        */
>       BUILD_BUG_ON(sizeof(CommandList_struct) % 8);
>
> -     printk(KERN_INFO DRIVER_NAME "\n");
> +     pr_info(DRIVER_NAME "\n");
>
>       err = bus_register(&cciss_bus_type);
>       if (err)
> @@ -4533,8 +4485,7 @@ static void __exit cciss_cleanup(void)
>       /* double check that all controller entrys have been removed */
>       for (i = 0; i < MAX_CTLR; i++) {
>               if (hba[i] != NULL) {
> -                     printk(KERN_WARNING "cciss: had to remove"
> -                            " controller %d\n", i);
> +                     pr_warning("had to remove controller %d\n", i);
>                       cciss_remove_one(hba[i]->pdev);
>               }
>       }
> @@ -4550,7 +4501,7 @@ static void fail_all_cmds(unsigned long ctlr)
>       CommandList_struct *c;
>       unsigned long flags;
>
> -     printk(KERN_WARNING "cciss%d: controller not
> responding.\n", h->ctlr);
> +     pr_warning("%d: controller not responding.\n", h->ctlr);
>       h->alive = 0;           /* the controller apparently died... */
>
>       spin_lock_irqsave(CCISS_LOCK(ctlr), flags); diff --git
> a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> index 5d0e46d..bd7d0c5 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -522,8 +522,8 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
>                       GFP_KERNEL);
>
>       if (!added || !removed) {
> -             printk(KERN_WARNING "cciss%d: Out of memory in "
> -                     "adjust_cciss_scsi_table\n", ctlr);
> +             pr_warning("%d: Out of memory in
> adjust_cciss_scsi_table\n",
> +                        ctlr);
>               goto free_and_out;
>       }
>
> @@ -609,8 +609,7 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
>               } else if (found == 1) {
>                       /* should never happen... */
>                       changes++;
> -                     printk(KERN_WARNING "cciss%d: device "
> -                             "unexpectedly changed\n", ctlr);
> +                     pr_warning("%d: device unexpectedly
> changed\n", ctlr);
>                       /* but if it does happen, we just
> ignore that device */
>               }
>       }
> @@ -634,10 +633,9 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
>                       /* We don't expect to get here. */
>                       /* future cmds to this device will get
> selection */
>                       /* timeout as if the device was gone. */
> -                     printk(KERN_WARNING "cciss%d: didn't find "
> -                             "c%db%dt%dl%d\n for removal.",
> -                             ctlr, hostno, removed[i].bus,
> -                             removed[i].target, removed[i].lun);
> +                     pr_warning("%d: didn't find
> c%db%dt%dl%d\n for removal.",
> +                                ctlr, hostno, removed[i].bus,
> +                                removed[i].target, removed[i].lun);
>               }
>       }
>
> @@ -648,10 +646,9 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
>                       added[i].target, added[i].lun);
>               if (rc == 0)
>                       continue;
> -             printk(KERN_WARNING "cciss%d: scsi_add_device "
> -                     "c%db%dt%dl%d failed, device not added.\n",
> -                     ctlr, hostno,
> -                     added[i].bus, added[i].target, added[i].lun);
> +             pr_warning("%d: scsi_add_device c%db%dt%dl%d
> failed, device not added.\n",
> +                        ctlr, hostno,
> +                        added[i].bus, added[i].target, added[i].lun);
>               /* now we have to remove it from ccissscsi, */
>               /* since it didn't get added to scsi mid layer */
>               fixup_botched_add(ctlr, added[i].scsi3addr); @@
> -750,10 +747,9 @@ complete_scsi_command( CommandList_struct
> *cp, int timeout, __u32 tag)
>                               if( ei->ScsiStatus)
>                               {
>  #if 0
> -                                     printk(KERN_WARNING
> "cciss: cmd %p "
> -                                     "has SCSI Status = %x\n",
> -                                             cp,
> -                                             ei->ScsiStatus);
> +                                     pr_warning("cmd %p has
> SCSI Status = %x\n",
> +                                                cp,
> +                                                ei->ScsiStatus);
>  #endif
>                                       cmd->result |=
> (ei->ScsiStatus << 1);
>                               }
> @@ -773,9 +769,8 @@ complete_scsi_command( CommandList_struct
> *cp, int timeout, __u32 tag)
>                       case CMD_DATA_UNDERRUN: /* let mid
> layer handle it. */
>                       break;
>                       case CMD_DATA_OVERRUN:
> -                             printk(KERN_WARNING "cciss: cp %p has"
> -                                     " completed with data overrun "
> -                                     "reported\n", cp);
> +                             pr_warning("cp %p has completed
> with data overrun reported\n",
> +                                        cp);
>                       break;
>                       case CMD_INVALID: {
>                               /* print_bytes(cp, sizeof(*cp),
> 1, 0); @@ -789,44 +784,37 @@ complete_scsi_command(
> CommandList_struct *cp, int timeout, __u32 tag)
>                               }
>                       break;
>                       case CMD_PROTOCOL_ERR:
> -                                printk(KERN_WARNING "cciss:
> cp %p has "
> -                                     "protocol error \n", cp);
> +                                pr_warning("cp %p has protocol
> + error\n", cp);
>                          break;
>                       case CMD_HARDWARE_ERR:
>                               cmd->result = DID_ERROR << 16;
> -                                printk(KERN_WARNING "cciss:
> cp %p had "
> -                                        " hardware error\n", cp);
> +                                pr_warning("cp %p had hardware
> + error\n", cp);
>                          break;
>                       case CMD_CONNECTION_LOST:
>                               cmd->result = DID_ERROR << 16;
> -                             printk(KERN_WARNING "cciss: cp %p had "
> -                                     "connection lost\n", cp);
> +                             pr_warning("cp %p had
> connection lost\n", cp);
>                       break;
>                       case CMD_ABORTED:
>                               cmd->result = DID_ABORT << 16;
> -                             printk(KERN_WARNING "cciss: cp %p was "
> -                                     "aborted\n", cp);
> +                             pr_warning("cp %p was aborted\n", cp);
>                       break;
>                       case CMD_ABORT_FAILED:
>                               cmd->result = DID_ERROR << 16;
> -                             printk(KERN_WARNING "cciss: cp
> %p reports "
> -                                     "abort failed\n", cp);
> +                             pr_warning("cp %p reports abort
> failed\n", cp);
>                       break;
>                       case CMD_UNSOLICITED_ABORT:
>                               cmd->result = DID_ABORT << 16;
> -                             printk(KERN_WARNING "cciss: cp
> %p aborted "
> -                                     "do to an unsolicited
> abort\n", cp);
> +                             pr_warning("cp %p aborted do to
> an unsolicited abort\n",
> +                                        cp);
>                       break;
>                       case CMD_TIMEOUT:
>                               cmd->result = DID_TIME_OUT << 16;
> -                             printk(KERN_WARNING "cciss: cp
> %p timedout\n",
> -                                     cp);
> +                             pr_warning("cp %p timedout\n", cp);
>                       break;
>                       default:
>                               cmd->result = DID_ERROR << 16;
> -                             printk(KERN_WARNING "cciss: cp
> %p returned "
> -                                     "unknown status %x\n", cp,
> -                                             ei->CommandStatus);
> +                             pr_warning("cp %p returned
> unknown status %x\n",
> +                                        cp, ei->CommandStatus);
>               }
>       }
>       // printk("c:%p:c%db%dt%dl%d ", cmd, ctlr->ctlr,
> cmd->channel, @@ -957,71 +945,54 @@
> cciss_scsi_interpret_error(CommandList_struct *cp)
>       switch(ei->CommandStatus)
>       {
>               case CMD_TARGET_STATUS:
> -                     printk(KERN_WARNING "cciss: cmd %p has "
> -                             "completed with errors\n", cp);
> -                     printk(KERN_WARNING "cciss: cmd %p "
> -                             "has SCSI Status = %x\n",
> -                                     cp,
> -                                     ei->ScsiStatus);
> +                     pr_warning("cmd %p has completed with
> errors\n", cp);
> +                     pr_warning("cmd %p has SCSI Status = %x\n",
> +                                cp, ei->ScsiStatus);
>                       if (ei->ScsiStatus == 0)
> -                             printk(KERN_WARNING
> -                             "cciss:SCSI status is
> abnormally zero.  "
> -                             "(probably indicates selection timeout "
> -                             "reported incorrectly due to a known "
> -                             "firmware bug, circa July, 2001.)\n");
> +                             pr_warning("SCSI status is
> abnormally zero.  (probably indicates
> +selection timeout reported incorrectly due to a known firmware bug,
> +circa July, 2001.)\n");
>               break;
>               case CMD_DATA_UNDERRUN: /* let mid layer handle it. */
>                       printk("UNDERRUN\n");
>               break;
>               case CMD_DATA_OVERRUN:
> -                     printk(KERN_WARNING "cciss: cp %p has"
> -                             " completed with data overrun "
> -                             "reported\n", cp);
> +                     pr_warning("cp %p has completed with
> data overrun reported\n",
> +                                cp);
>               break;
>               case CMD_INVALID: {
>                       /* controller unfortunately reports
> SCSI passthru's */
>                       /* to non-existent targets as invalid
> commands. */
> -                     printk(KERN_WARNING "cciss: cp %p is "
> -                             "reported invalid (probably means "
> -                             "target device no longer present)\n",
> -                             cp);
> +                     pr_warning("cp %p is reported invalid
> (probably means target device no longer present)\n",
> +                                cp);
>                       /* print_bytes((unsigned char *) cp,
> sizeof(*cp), 1, 0);
>                       print_cmd(cp);  */
>                       }
>               break;
>               case CMD_PROTOCOL_ERR:
> -                     printk(KERN_WARNING "cciss: cp %p has "
> -                             "protocol error \n", cp);
> +                     pr_warning("cp %p has protocol error\n", cp);
>               break;
>               case CMD_HARDWARE_ERR:
>                       /* cmd->result = DID_ERROR << 16; */
> -                     printk(KERN_WARNING "cciss: cp %p had "
> -                             " hardware error\n", cp);
> +                     pr_warning("cp %p had hardware error\n", cp);
>               break;
>               case CMD_CONNECTION_LOST:
> -                     printk(KERN_WARNING "cciss: cp %p had "
> -                             "connection lost\n", cp);
> +                     pr_warning("cp %p had connection lost\n", cp);
>               break;
>               case CMD_ABORTED:
> -                     printk(KERN_WARNING "cciss: cp %p was "
> -                             "aborted\n", cp);
> +                     pr_warning("cp %p was aborted\n", cp);
>               break;
>               case CMD_ABORT_FAILED:
> -                     printk(KERN_WARNING "cciss: cp %p reports "
> -                             "abort failed\n", cp);
> +                     pr_warning("cp %p reports abort failed\n", cp);
>               break;
>               case CMD_UNSOLICITED_ABORT:
> -                     printk(KERN_WARNING "cciss: cp %p aborted "
> -                             "do to an unsolicited abort\n", cp);
> +                     pr_warning("cp %p aborted do to an
> unsolicited abort\n",
> +                                cp);
>               break;
>               case CMD_TIMEOUT:
> -                     printk(KERN_WARNING "cciss: cp %p timedout\n",
> -                             cp);
> +                     pr_warning("cp %p timedout\n", cp);
>               break;
>               default:
> -                     printk(KERN_WARNING "cciss: cp %p returned "
> -                             "unknown status %x\n", cp,
> -                                     ei->CommandStatus);
> +                     pr_warning("cp %p returned unknown status %x\n",
> +                                cp, ei->CommandStatus);
>       }
>  }
>
> @@ -1188,7 +1159,7 @@ cciss_update_non_disk_devices(int
> cntl_num, int hostno)
>       currentsd = kzalloc(sizeof(*currentsd) *
>                       (CCISS_MAX_SCSI_DEVS_PER_HBA+1), GFP_KERNEL);
>       if (ld_buff == NULL || inq_buff == NULL || currentsd == NULL) {
> -             printk(KERN_ERR "cciss: out of memory\n");
> +             pr_err("out of memory\n");
>               goto out;
>       }
>       this_device = &currentsd[CCISS_MAX_SCSI_DEVS_PER_HBA];
> @@ -1196,15 +1167,14 @@ cciss_update_non_disk_devices(int
> cntl_num, int hostno)
>               ch = &ld_buff->LUNListLength[0];
>               num_luns = ((ch[0]<<24) | (ch[1]<<16) |
> (ch[2]<<8) | ch[3]) / 8;
>               if (num_luns > CISS_MAX_PHYS_LUN) {
> -                     printk(KERN_WARNING
> -                             "cciss: Maximum physical LUNs
> (%d) exceeded.  "
> -                             "%d LUNs ignored.\n",
> CISS_MAX_PHYS_LUN,
> -                             num_luns - CISS_MAX_PHYS_LUN);
> +                     pr_warning("Maximum physical LUNs (%d)
> exceeded.  %d LUNs ignored.\n",
> +                                CISS_MAX_PHYS_LUN,
> +                                num_luns - CISS_MAX_PHYS_LUN);
>                       num_luns = CISS_MAX_PHYS_LUN;
>               }
>       }
>       else {
> -             printk(KERN_ERR  "cciss: Report physical LUNs
> failed.\n");
> +             pr_err("Report physical LUNs failed.\n");
>               goto out;
>       }
>
> @@ -1260,8 +1230,8 @@ cciss_update_non_disk_devices(int
> cntl_num, int hostno)
>                 case 0x01: /* sequential access, (tape) */
>                 case 0x08: /* medium changer */
>                       if (ncurrent >= CCISS_MAX_SCSI_DEVS_PER_HBA) {
> -                             printk(KERN_INFO "cciss%d: %s ignored, "
> -                                     "too many devices.\n", cntl_num,
> +                             pr_info("%d: %s ignored, too
> many devices.\n",
> +                                     cntl_num,
>
> scsi_device_type(this_device->devtype));
>                               break;
>                       }
> @@ -1578,8 +1548,8 @@ static int
> wait_for_device_to_become_ready(ctlr_info_t *h,
>
>       c = cmd_alloc(h, 1);
>       if (!c) {
> -             printk(KERN_WARNING "cciss%d: out of memory in "
> -                     "wait_for_device_to_become_ready.\n", h->ctlr);
> +             pr_warning("%d: out of memory in
> wait_for_device_to_become_ready.\n",
> +                        h->ctlr);
>               return IO_ERROR;
>       }
>
> @@ -1623,16 +1593,15 @@ static int
> wait_for_device_to_become_ready(ctlr_info_t *h,
>                       }
>               }
>  retry_tur:
> -             printk(KERN_WARNING "cciss%d: Waiting %d secs "
> -                     "for device to become ready.\n",
> -                     h->ctlr, waittime / HZ);
> +             pr_warning("%d: Waiting %d secs for device to
> become ready.\n",
> +                        h->ctlr, waittime / HZ);
>               rc = 1; /* device not ready. */
>       }
>
>       if (rc)
>               printk("cciss%d: giving up on device.\n", h->ctlr);
>       else
> -             printk(KERN_WARNING "cciss%d: device is
> ready.\n", h->ctlr);
> +             pr_warning("%d: device is ready.\n", h->ctlr);
>
>       cmd_free(h, c, 1);
>       return rc;
> @@ -1662,7 +1631,7 @@ static int
> cciss_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
>       if (c == NULL) /* paranoia */
>               return FAILED;
>       ctlr = (*c)->ctlr;
> -     printk(KERN_WARNING "cciss%d: resetting tape drive or
> medium changer.\n", ctlr);
> +     pr_warning("%d: resetting tape drive or medium
> changer.\n", ctlr);
>       /* find the command that's giving us trouble */
>       cmd_in_trouble = (CommandList_struct *) scsicmd->host_scribble;
>       if (cmd_in_trouble == NULL) /* paranoia */ @@ -1673,7
> +1642,7 @@ static int cciss_eh_device_reset_handler(struct
> scsi_cmnd *scsicmd)
>               TYPE_MSG);
>       if (rc == 0 && wait_for_device_to_become_ready(*c,
> lunaddr) == 0)
>               return SUCCESS;
> -     printk(KERN_WARNING "cciss%d: resetting device
> failed.\n", ctlr);
> +     pr_warning("%d: resetting device failed.\n", ctlr);
>       return FAILED;
>  }
>
> @@ -1690,7 +1659,7 @@ static int
> cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
>       if (c == NULL) /* paranoia */
>               return FAILED;
>       ctlr = (*c)->ctlr;
> -     printk(KERN_WARNING "cciss%d: aborting tardy SCSI cmd\n", ctlr);
> +     pr_warning("%d: aborting tardy SCSI cmd\n", ctlr);
>
>       /* find the command to be aborted */
>       cmd_to_abort = (CommandList_struct *) scsicmd->host_scribble;
> --
> 1.6.6.rc0.57.gad7a
>
>
