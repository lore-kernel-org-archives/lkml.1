Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbZJVPjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbZJVPjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbZJVPjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:39:20 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:58752 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbZJVPjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:39:18 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Fix null pointer error after vmbus loading
Thread-Topic: [PATCH] Fix null pointer error after vmbus loading
Thread-Index: AcpShBhhaH+7AN1gRFKVV/A3W6FqAwAVoFqAABKi7GA=
Date: Thu, 22 Oct 2009 15:39:05 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF72180B3D51@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF72180B39CA@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20091021224337.GA8550@suse.de>
In-Reply-To: <20091021224337.GA8550@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >         /* Make sure we are not registered already */
> > -       if (strlen(dev_name(&child_device_ctx->device)) != 0) {
> > +       if (dev_name(&child_device_ctx->device) != NULL &&
> > +           strlen(dev_name(&child_device_ctx->device)) != 0) {
> 
> Why would the device name ever be NULL?  Why would you need to check it
> here?

In recently kernel versions, char bus_id[BUS_ID_SIZE] in struct device has been replaced by char* type kobj.name, which is NULL if name is not yet set.
The function vmbus_child_device_create() alloc the memory for struct device_context, which includes struct device as a member. All data are initialized to zero, so the device name ptr, aka kobj.name, is NULL at the beginning:
	child_device_ctx = kzalloc(sizeof(struct device_context), GFP_KERNEL);
So, a NULL pointer checking is added to avoid null pointer dereference error if strlen() is called on the NULL name pointer. After we confirm the device isn't registered yet, we will set the name and register the device.

BTW, I forgot to switch to TXT mode in my last email, I will resend the patch in TXT only mode.

Thanks,

- Haiyang

