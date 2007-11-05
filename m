Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbXKEPM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbXKEPM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 10:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXKEPMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 10:12:48 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:40632 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbXKEPMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 10:12:47 -0500
From: Swen Schillig <swen@vnet.ibm.com>
Organization: IBM
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: add some internal zfcp adapter statistics
Date: Mon, 5 Nov 2007 16:12:43 +0100
User-Agent: KMail/1.9.5
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       linux-scsi@vger.kernel.org, Linux on 390 Port <LINUX-390@vm.marist.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200710311133.52090.swen@vnet.ibm.com> <20071103091722.GA7807@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20071103091722.GA7807@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711051612.44273.swen@vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 November 2007 10:17, Heiko Carstens wrote:
> > +static void zfcp_fsf_req_latency(struct zfcp_fsf_req *fsf_req)
> > +{
> > +	struct fsf_qual_latency_info *lat_inf;
> > +	struct zfcp_unit *unit;
> > +
> > +	lat_inf = &fsf_req->qtcb->prefix.prot_status_qual.latency_info;
> > +	unit = fsf_req->unit;
> > +
> > +	switch (fsf_req->qtcb->bottom.io.data_direction) {
> > +	case FSF_DATADIR_READ:
> > +		unit->latencies.read.channel += lat_inf->channel_lat;
> > +		unit->latencies.read.fabric += lat_inf->fabric_lat;
> > +		unit->latencies.read.counter++;
> > +		break;
> > +	case FSF_DATADIR_WRITE:
> > +		unit->latencies.write.channel += lat_inf->channel_lat;
> > +		unit->latencies.write.fabric += lat_inf->fabric_lat;
> > +		unit->latencies.write.counter++;
> > +		break;
> > +	case FSF_DATADIR_CMND:
> > +		unit->latencies.cmd.channel += lat_inf->channel_lat;
> > +		unit->latencies.cmd.fabric += lat_inf->fabric_lat;
> > +		unit->latencies.cmd.counter++;
> > +		break;
> > +	}
> > +}
> 
> These statistics are concurrently updated from several cpus without
> any locking. That looks like a bug.
> 
> > +zfcp_sysfs_unit_##_name##_latency_show(struct device *dev,		\
> > +				       struct device_attribute *attr,	\
> > +				       char *buf) {			\
> > +	struct scsi_device *sdev = to_scsi_device(dev);			\
> > +	struct zfcp_unit *unit = sdev->hostdata;			\
> > +	struct zfcp_latencies *lat = &unit->latencies;			\
> > +	struct zfcp_adapter *adapter = unit->port->adapter;		\
> > +									\
> > +	return sprintf(buf, "%u %u %u\n",				\
> > +		       lat->_name.fabric * adapter->timer_ticks / 1000, \
> > +		       lat->_name.channel * adapter->timer_ticks / 1000,\
> > +		       lat->_name.counter);				\
> 
> In addition they can be read concurrently from userspace without any
> locking... Since you put several values together in the output I assume
> this is supposed to be some sort of snapshot, which it currently isn't.
> 
> > +static int
> > +zfcp_sysfs_adapter_ex_config(struct class_device *cdev,
> > +			     struct fsf_qtcb_bottom_config **qtcb_config)
> > +{
> > +	struct Scsi_Host *scsi_host = class_to_shost(cdev);
> > +	struct zfcp_adapter *adapter = (struct zfcp_adapter *)
> > +						scsi_host->hostdata[0];
> > +
> > +	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA)) {
> > +		ZFCP_LOG_NORMAL("error: Enhanced measurement feature not "
> > +				"supported");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	*qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
> > +			       GFP_KERNEL);
> > +	if (!*qtcb_config)
> > +		return -ENOMEM;
> > +
> > +	return zfcp_fsf_exchange_config_data_sync(adapter, *qtcb_config);
> > +}
> > +
> > +static ssize_t
> > +zfcp_sysfs_adapter_request_show(struct class_device *cdev, char *buf)
> > +{
> > +	struct fsf_qtcb_bottom_config *qtcb_config;
> > +	int retval;
> > +
> > +	retval = zfcp_sysfs_adapter_ex_config(cdev, &qtcb_config);
> > +
> > +	if (!retval)
> > +		retval = sprintf(buf, "%lu %lu %lu\n",
> > +				 qtcb_config->stat_info.input_req,
> > +				 qtcb_config->stat_info.output_req,
> > +				 qtcb_config->stat_info.control_req);
> > +
> > +	kfree(qtcb_config);
> > +	return retval;
> > +}
> 
> You're going to call kfree with some random value if the adapter doesn't
> support the measurement data feature.
> 
Ok, valid points. 
I changed the patch to meet the above described issues.
Before I will post the modified version I want to do some testing (and an internal review).

The updated version will follow soon (hopefully this week), thanks for reviewing.

Cheers Swen
