Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbYJBHS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbYJBHS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 03:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYJBHST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 03:18:19 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:41109 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYJBHST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 03:18:19 -0400
Message-ID: <53152.166.70.238.43.1222929704.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <44010.166.70.238.43.1222928236.squirrel@webmail.wolfmountaingroup.com
     >
References: <44010.166.70.238.43.1222928236.squirrel@webmail.wolfmountaingroup.com>
Date: Thu, 2 Oct 2008 00:41:44 -0600 (MDT)
Subject: Re: do_filp_open fails to detect dentry revalidate of 1 and crashes
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On assignment of a negative dentry, do_filp_open will crash with an oops
> in do_sys_open because do_filp_open returns "1" from revalidate rather
> than properly detect a negative dentry which has a dentry revalidate
> function before the file actually exists.
>
>
> Easy to reproduce.  Create negative dentry and attach a revalidate
> function which returns 1 instead of 0 on non-existent file entry.   The
> convoluted code in do_filp_open does not detect dentry errors in all cases
> properly.
>
> Jeff
>

Correction:

It's vfs_create that fails to check return codes properly.

        /*
         * Create - we need to know the parent.
         */
        error = path_lookup_create(dfd, pathname, LOOKUP_PARENT,
                                   &nd, flag, mode);


////
If ERROR is a positive value, ERR_PTR fails to convert it to a negative
value.  This causes the EDI register to get set to "1" after do_filp_open
returns.

////

        if (error)
                return ERR_PTR(error);



        /*
         * We have the parent and last component. First of all, check
         * that we are not asked to creat(2) an obvious directory - that
         * will not do.
         */
        error = -EISDIR;
        if (nd.last_type != LAST_NORM || nd.last.name[nd.last.len])
                goto exit;


