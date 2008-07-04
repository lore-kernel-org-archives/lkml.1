Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbYGDHvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbYGDHvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 03:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYGDHvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 03:51:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:12070 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYGDHvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 03:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SCtTEJBcTsX2rzoB35o6CnR+ZK/0ITAWGJ3VkEmis1yF0U9uSrow4vp13Enmp28wn2
         HaQE/3wix8Yv3BE/PXHhaDcRhyX5TnUeOPwaYAsZJ1vMYDMRLAhmhXuEmVbqHMOca8kE
         do1qqEcOplJh8gzsO3+bJognIcOrN0guvpY2c=
Message-ID: <486DD650.3000804@gmail.com>
Date: Fri, 04 Jul 2008 16:50:40 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support
 for device classes.
References: <20080618170729.808539948@theryb.frec.bull.fr>	<m1ej6d9c2r.fsf@frodo.ebiederm.org> <486B060C.7030607@gmail.com>	<m14p78s02q.fsf@frodo.ebiederm.org> <486C4515.1070007@gmail.com>	<m1hcb7o8lv.fsf@frodo.ebiederm.org> <486CB051.5000507@fr.ibm.com>	<m14p77m9uy.fsf@frodo.ebiederm.org> <486CF71F.5090405@gmail.com>	<m1y74iiidz.fsf_-_@frodo.ebiederm.org>	<m1tzf6ihlz.fsf_-_@frodo.ebiederm.org>	<m1prpuihjb.fsf_-_@frodo.ebiederm.org>	<m1lk0iihhp.fsf_-_@frodo.ebiederm.org>	<m1hcb6ihfz.fsf_-_@frodo.ebiederm.org>	<m1d4luihea.fsf_-_@frodo.ebiederm.org>	<m18wwiihbn.fsf_-_@frodo.ebiederm.org>	<m14p76ih9a.fsf_-_@frodo.ebiederm.org>	<m1zloyh2mb.fsf_-_@frodo.ebiederm.org>	<m1vdzmh2jr.fsf_-_@frodo.ebiederm.org>	<m1r6aah2hh.fsf_-_@frodo.ebiederm.org>	<m1mykyh2fu.fsf_-_@frodo.ebiederm.org> <m1hcb6h2d2.fsf_-_@frodo.ebiederm.org>
In-Reply-To: <m1hcb6h2d2.fsf_-_@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> This patch enables tagging on every class directory if struct class
> has a tag_type.
> 
> In addition device_del and device_rename were modified to uses
> sysfs_delete_link and sysfs_rename_link respectively to ensure
> when these operations happen on devices whose classes have
> tag_ops that they work properly.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>

Okay, I went through the users this time but I still think
determine-tags-by-callbacks is a bad idea.  Please just add const void
*tag to kobject and set it during initialization.  If you want to move a
device from one tag to another, implement kobject_rename_tagged(kobj,
new_name, new_tag).

The determine-tag-by-callback basically multiplexes basic functions to
do tag-specific things which are determined by ktype callback called
back from down the layer.  It's simply a bad interface.  Those
operations become something else depending on how those callbacks
behave.  That's unnecessarily subtle.  Advertising what it's gonna do in
the function name and as arguments is way more straight forward and it's
not like determining or renaming tags should be done asynchronously.

I personally think it would be better to make tags explicit in the mount
interface too but if extracting ns information from the mounting process
is what's currently being done, well...

I'm sorry but Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
