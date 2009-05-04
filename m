Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZEDTal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZEDTal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZEDTaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:30:30 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:33284 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZEDTa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:30:29 -0400
Message-ID: <49FF4249.7030907@oracle.com>
Date: Mon, 04 May 2009 12:30:17 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jan Kucera <xatrix101@gmail.com>
CC: mfasheh@suse.com, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] Deadlock in dlmmaster.c
References: <ef67228d0905031333i782ad1efhe532cd555e58b604@mail.gmail.com>
In-Reply-To: <ef67228d0905031333i782ad1efhe532cd555e58b604@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49FF424B.02D8,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kucera wrote:
> I've found some possible deadlock in fs/ocfs2/dlm/dlmmaster.c - 
> version 2.6.28 (probably this code is in newer versions too).
> Could someone confirm this? Thank you.
>
>
> fs/ocfs2/dlm/dlmmaster.c
> ==================
>
> function dlm_master_request_handler: (res->spinlock <- dlm->master_lock)
> -----------------------------------
> spin_lock(&res->spinlock); at line 1427
> spin_lock(&dlm->master_lock); at line 1475
>
> function dlm_migrate_request_handler: (dlm->master_lock <- res->spinlock)
> -------------------------------------------------------
> spin_lock(&dlm->master_lock) at line 3036
> spin_lock(&res->spinlock); at line 3039

So this should not happen.

The first condition can only be hit if the resource has no master and is in
the process of being mastered.

The second condition will only be hit if the resource has a master and is
currently being migrated (remastered) from one node to another.

The two appear to be mutually exclusive. But feel free to file a bugzilla
so that I remember to look into it more carefully when I have more time.
http://oss.oracle.com/bugzilla

Thanks
Sunil
