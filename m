Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbXJaKdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbXJaKdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbXJaKdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:33:41 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:12981 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbXJaKdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:33:39 -0400
From: Swen Schillig <swen@vnet.ibm.com>
To: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] zfcp: add some internal zfcp adapter statistics
Date: Wed, 31 Oct 2007 11:33:51 +0100
User-Agent: KMail/1.9.5
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org,
       Linux on 390 Port <LINUX-390@vm.marist.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Organization: IBM
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710311133.52090.swen@vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Swen Schillig <swen@vnet.ibm.com>

add some statistics provided by the zFCP adapter to the sysfs

The new zFCP adapter statistics provide a variety of information
about the virtual adapter (subchannel). In order to collect this information
the zFCP driver is extended on one side to query the adapter and
on the other side summarize certain values which can then be fetched on demand.
This information is made available via files(attributes) in the sysfs filesystem.

The information provided by the new zFCP adapter statistics can be fetched
by reading from the following files in the sysfs filesystem

 /sys/class/scsi_host/host<n>/seconds_active
 /sys/class/scsi_host/host<n>/requests
 /sys/class/scsi_host/host<n>/megabytes
 /sys/class/scsi_host/host<n>/utilization

These are the statistics on a virtual adapter (subchannel) level.
In addition latency information is provided on a SCSI device level (LUN) which
can be found at the following location

 /sys/class/scsi_device/<H:C:T:L>/device/cmd_latency
 /sys/class/scsi_device/<H:C:T:L>/device/read_latency
 /sys/class/scsi_device/<H:C:T:L>/device/write_latency


The information provided is raw and not modified or interpreted by any means.
No interpretation or modification of the values is done by the zFCP driver.
The individual values are summed up during normal operation of the virtual adapter.
An overrun of the variables is neither detected nor treated. The conclusion is that
the file has to be read twice to make a meaningful statement, because only the differences of the values
between the two reads can be used.

The statistics make use of the SCSI mid-layer interface to provide its data to the user.
In detail two hooks from the scsi_host_template are used to integrate
the zFCP statistics.

    struct scsi_host_template {
            ...
            .shost_attrs = zfcp_a_stats_attrs,
            .sdev_attrs  = zfcp_sysfs_sdev_attrs,
            ...
    };


Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>

---
 drivers/s390/scsi/zfcp_def.h  |   13 +++
 drivers/s390/scsi/zfcp_fsf.c  |   36 ++++++++++
 drivers/s390/scsi/zfcp_fsf.h  |   29 +++++++-
 drivers/s390/scsi/zfcp_scsi.c |  148 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 223 insertions(+), 3 deletions(-)

Index: scsi-misc/drivers/s390/scsi/zfcp_def.h
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_def.h
+++ scsi-misc/drivers/s390/scsi/zfcp_def.h
@@ -868,6 +868,17 @@ struct zfcp_erp_action {
 	struct timer_list timer;
 };
 
+struct latency_cont {
+	u32 channel;
+	u32 fabric;
+	u32 counter;
+};
+
+struct zfcp_latencies {
+	struct latency_cont read;
+	struct latency_cont write;
+	struct latency_cont cmd;
+};
 
 struct zfcp_adapter {
 	struct list_head	list;              /* list of adapters */
@@ -883,6 +894,7 @@ struct zfcp_adapter {
 	u32			adapter_features;  /* FCP channel features */
 	u32			connection_features; /* host connection features */
         u32			hardware_version;  /* of FCP channel */
+	u16			timer_ticks;       /* time int for a tick */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
 	struct list_head	port_list_head;	   /* remote port list */
 	struct list_head        port_remove_lh;    /* head of ports to be
@@ -986,6 +998,7 @@ struct zfcp_unit {
 						  all scsi_scan_target
 						  requests have been
 						  completed. */
+	struct zfcp_latencies	latencies;
 };
 
 /* FSF request */
Index: scsi-misc/drivers/s390/scsi/zfcp_fsf.c
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_fsf.c
+++ scsi-misc/drivers/s390/scsi/zfcp_fsf.c
@@ -2079,6 +2079,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 		fc_host_supported_classes(shost) =
 				FC_COS_CLASS2 | FC_COS_CLASS3;
 		adapter->hydra_version = bottom->adapter_type;
+		adapter->timer_ticks = bottom->timer_interval;
 		if (fc_host_permanent_port_name(shost) == -1)
 			fc_host_permanent_port_name(shost) =
 				fc_host_port_name(shost);
@@ -3823,6 +3824,33 @@ zfcp_fsf_send_fcp_command_task_managemen
 	return fsf_req;
 }
 
+static void zfcp_fsf_req_latency(struct zfcp_fsf_req *fsf_req)
+{
+	struct fsf_qual_latency_info *lat_inf;
+	struct zfcp_unit *unit;
+
+	lat_inf = &fsf_req->qtcb->prefix.prot_status_qual.latency_info;
+	unit = fsf_req->unit;
+
+	switch (fsf_req->qtcb->bottom.io.data_direction) {
+	case FSF_DATADIR_READ:
+		unit->latencies.read.channel += lat_inf->channel_lat;
+		unit->latencies.read.fabric += lat_inf->fabric_lat;
+		unit->latencies.read.counter++;
+		break;
+	case FSF_DATADIR_WRITE:
+		unit->latencies.write.channel += lat_inf->channel_lat;
+		unit->latencies.write.fabric += lat_inf->fabric_lat;
+		unit->latencies.write.counter++;
+		break;
+	case FSF_DATADIR_CMND:
+		unit->latencies.cmd.channel += lat_inf->channel_lat;
+		unit->latencies.cmd.fabric += lat_inf->fabric_lat;
+		unit->latencies.cmd.counter++;
+		break;
+	}
+}
+
 /*
  * function:    zfcp_fsf_send_fcp_command_handler
  *
@@ -4036,9 +4064,17 @@ zfcp_fsf_send_fcp_command_handler(struct
 		break;
 
 	case FSF_GOOD:
+		if (fsf_req->adapter->adapter_features &
+		    FSF_FEATURE_MEASUREMENT_DATA)
+			zfcp_fsf_req_latency(fsf_req);
 		break;
 
 	case FSF_FCP_RSP_AVAILABLE:
+		if ((fsf_req->qtcb->prefix.prot_status &
+		     FSF_PROT_FSF_STATUS_PRESENTED) &&
+		    (fsf_req->adapter->adapter_features &
+		     FSF_FEATURE_MEASUREMENT_DATA))
+			zfcp_fsf_req_latency(fsf_req);
 		break;
 
 	default:
Index: scsi-misc/drivers/s390/scsi/zfcp_fsf.h
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_fsf.h
+++ scsi-misc/drivers/s390/scsi/zfcp_fsf.h
@@ -213,6 +213,7 @@
 #define FSF_FEATURE_HBAAPI_MANAGEMENT           0x00000010
 #define FSF_FEATURE_ELS_CT_CHAINED_SBALS        0x00000020
 #define FSF_FEATURE_UPDATE_ALERT		0x00000100
+#define FSF_FEATURE_MEASUREMENT_DATA		0x00000200
 
 /* host connection features */
 #define FSF_FEATURE_NPIV_MODE			0x00000001
@@ -322,11 +323,18 @@ struct fsf_link_down_info {
 	u8 vendor_specific_code;
 } __attribute__ ((packed));
 
+struct fsf_qual_latency_info {
+	u32 channel_lat;
+	u32 fabric_lat;
+	u8 res1[8];
+} __attribute__ ((packed));
+
 union fsf_prot_status_qual {
 	u64 doubleword[FSF_PROT_STATUS_QUAL_SIZE / sizeof(u64)];
 	struct fsf_qual_version_error   version_error;
 	struct fsf_qual_sequence_error  sequence_error;
 	struct fsf_link_down_info link_down_info;
+	struct fsf_qual_latency_info latency_info;
 } __attribute__ ((packed));
 
 struct fsf_qtcb_prefix {
@@ -340,6 +348,15 @@ struct fsf_qtcb_prefix {
 	u8  res1[20];
 } __attribute__ ((packed));
 
+struct fsf_statistics_info {
+	u64 input_req;
+	u64 output_req;
+	u64 control_req;
+	u64 input_mb;
+	u64 output_mb;
+	u64 seconds_act;
+} __attribute__ ((packed));
+
 union fsf_status_qual {
 	u8  byte[FSF_STATUS_QUALIFIER_SIZE];
 	u16 halfword[FSF_STATUS_QUALIFIER_SIZE / sizeof (u16)];
@@ -427,7 +444,9 @@ struct fsf_qtcb_bottom_config {
 	u32 fc_link_speed;
 	u32 adapter_type;
 	u32 peer_d_id;
-	u8 res2[12];
+	u8 res1[2];
+	u16 timer_interval;
+	u8 res2[8];
 	u32 s_id;
 	struct fsf_nport_serv_param nport_serv_param;
 	u8 reserved_nport_serv_param[16];
@@ -436,7 +455,8 @@ struct fsf_qtcb_bottom_config {
 	u32 hardware_version;
 	u8 serial_number[32];
 	struct fsf_nport_serv_param plogi_payload;
-	u8 res4[160];
+	struct fsf_statistics_info stat_info;
+	u8 res4[112];
 } __attribute__ ((packed));
 
 struct fsf_qtcb_bottom_port {
@@ -469,7 +489,10 @@ struct fsf_qtcb_bottom_port {
 	u64 control_requests;
 	u64 input_mb;		/* where 1 MByte == 1.000.000 Bytes */
 	u64 output_mb;		/* where 1 MByte == 1.000.000 Bytes */
-	u8 res2[256];
+	u8 cp_util;
+	u8 cb_util;
+	u8 a_util;
+	u8 res2[253];
 } __attribute__ ((packed));
 
 union fsf_qtcb_bottom {
Index: scsi-misc/drivers/s390/scsi/zfcp_scsi.c
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_scsi.c
+++ scsi-misc/drivers/s390/scsi/zfcp_scsi.c
@@ -39,6 +39,7 @@ static struct zfcp_unit *zfcp_unit_looku
 					  unsigned int, unsigned int);
 
 static struct device_attribute *zfcp_sysfs_sdev_attrs[];
+static struct class_device_attribute *zfcp_a_stats_attrs[];
 
 struct zfcp_data zfcp_data = {
 	.scsi_host_template = {
@@ -60,6 +61,7 @@ struct zfcp_data zfcp_data = {
 		.use_clustering		= 1,
 		.sdev_attrs		= zfcp_sysfs_sdev_attrs,
 		.max_sectors		= ZFCP_MAX_SECTORS,
+		.shost_attrs		= zfcp_a_stats_attrs,
 	},
 	.driver_version = ZFCP_VERSION,
 };
@@ -803,6 +805,28 @@ struct fc_function_template zfcp_transpo
 	.disable_target_scan = 1,
 };
 
+#define ZFCP_DEFINE_LATENCY_ATTR(_name) 				\
+static ssize_t 								\
+zfcp_sysfs_unit_##_name##_latency_show(struct device *dev,		\
+				       struct device_attribute *attr,	\
+				       char *buf) {			\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	struct zfcp_unit *unit = sdev->hostdata;			\
+	struct zfcp_latencies *lat = &unit->latencies;			\
+	struct zfcp_adapter *adapter = unit->port->adapter;		\
+									\
+	return sprintf(buf, "%u %u %u\n",				\
+		       lat->_name.fabric * adapter->timer_ticks / 1000, \
+		       lat->_name.channel * adapter->timer_ticks / 1000,\
+		       lat->_name.counter);				\
+}									\
+static DEVICE_ATTR(_name##_latency, S_IRUGO,				\
+		   zfcp_sysfs_unit_##_name##_latency_show, NULL);
+
+ZFCP_DEFINE_LATENCY_ATTR(read);
+ZFCP_DEFINE_LATENCY_ATTR(write);
+ZFCP_DEFINE_LATENCY_ATTR(cmd);
+
 /**
  * ZFCP_DEFINE_SCSI_ATTR
  * @_name:   name of show attribute
@@ -833,6 +857,130 @@ static struct device_attribute *zfcp_sys
 	&dev_attr_fcp_lun,
 	&dev_attr_wwpn,
 	&dev_attr_hba_id,
+	&dev_attr_read_latency,
+	&dev_attr_write_latency,
+	&dev_attr_cmd_latency,
+	NULL
+};
+
+
+static ssize_t
+zfcp_sysfs_adapter_utilization_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *scsi_host = class_to_shost(cdev);
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *)
+						scsi_host->hostdata[0];
+	struct fsf_qtcb_bottom_port *qtcb_port;
+	int retval;
+
+	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA)) {
+		ZFCP_LOG_NORMAL("error: Enhanced measurement feature not "
+				"supported");
+		return -EOPNOTSUPP;
+	}
+
+	qtcb_port = kzalloc(sizeof(struct fsf_qtcb_bottom_port), GFP_KERNEL);
+	if (!qtcb_port)
+		return -ENOMEM;
+
+	retval = zfcp_fsf_exchange_port_data_sync(adapter, qtcb_port);
+	if (!retval)
+		retval = sprintf(buf, "%u %u %u\n", qtcb_port->cp_util,
+				 qtcb_port->cb_util, qtcb_port->a_util);
+	kfree(qtcb_port);
+	return retval;
+}
+
+static
+CLASS_DEVICE_ATTR(utilization, S_IRUGO, zfcp_sysfs_adapter_utilization_show,
+		   NULL);
+
+static int
+zfcp_sysfs_adapter_ex_config(struct class_device *cdev,
+			     struct fsf_qtcb_bottom_config **qtcb_config)
+{
+	struct Scsi_Host *scsi_host = class_to_shost(cdev);
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *)
+						scsi_host->hostdata[0];
+
+	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA)) {
+		ZFCP_LOG_NORMAL("error: Enhanced measurement feature not "
+				"supported");
+		return -EOPNOTSUPP;
+	}
+
+	*qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
+			       GFP_KERNEL);
+	if (!*qtcb_config)
+		return -ENOMEM;
+
+	return zfcp_fsf_exchange_config_data_sync(adapter, *qtcb_config);
+}
+
+static ssize_t
+zfcp_sysfs_adapter_request_show(struct class_device *cdev, char *buf)
+{
+	struct fsf_qtcb_bottom_config *qtcb_config;
+	int retval;
+
+	retval = zfcp_sysfs_adapter_ex_config(cdev, &qtcb_config);
+
+	if (!retval)
+		retval = sprintf(buf, "%lu %lu %lu\n",
+				 qtcb_config->stat_info.input_req,
+				 qtcb_config->stat_info.output_req,
+				 qtcb_config->stat_info.control_req);
+
+	kfree(qtcb_config);
+	return retval;
+}
+
+static CLASS_DEVICE_ATTR(requests, S_IRUGO, zfcp_sysfs_adapter_request_show,
+NULL);
+
+static ssize_t
+zfcp_sysfs_adapter_mb_show(struct class_device *cdev, char *buf)
+{
+	struct fsf_qtcb_bottom_config *qtcb_config;
+	int retval;
+
+	retval = zfcp_sysfs_adapter_ex_config(cdev, &qtcb_config);
+
+	if (!retval)
+		retval = sprintf(buf, "%lu %lu\n",
+				 qtcb_config->stat_info.input_mb,
+				 qtcb_config->stat_info.output_mb);
+
+	kfree(qtcb_config);
+	return retval;
+}
+
+static CLASS_DEVICE_ATTR(megabytes, S_IRUGO, zfcp_sysfs_adapter_mb_show, NULL);
+
+static ssize_t
+zfcp_sysfs_adapter_seconds_active_show(struct class_device *cdev, char *buf)
+{
+	struct fsf_qtcb_bottom_config *qtcb_config;
+	int retval;
+
+	retval = zfcp_sysfs_adapter_ex_config(cdev, &qtcb_config);
+	if (!retval)
+		retval = sprintf(buf, "%lu\n",
+				 qtcb_config->stat_info.seconds_act);
+
+	kfree(qtcb_config);
+	return retval;
+}
+
+static CLASS_DEVICE_ATTR(seconds_active, S_IRUGO,
+		   zfcp_sysfs_adapter_seconds_active_show, NULL);
+
+
+static struct class_device_attribute *zfcp_a_stats_attrs[] = {
+	&class_device_attr_utilization,
+	&class_device_attr_requests,
+	&class_device_attr_megabytes,
+	&class_device_attr_seconds_active,
 	NULL
 };
