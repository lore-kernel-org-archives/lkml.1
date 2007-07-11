Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbXGKIWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbXGKIWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXGKIWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:22:08 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:60173 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbXGKIWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:22:06 -0400
Subject: [PATCH RFC] try_module_get usage
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dedekind@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 11 Jul 2007 16:55:31 +0900
Message-Id: <1184140531.4608.16.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I keep seeing uses of try_module_get(THIS_MODULE) which seem to mimic
the behavior of the former MOD_INC_USE_COUNT. The UBI driver is one
example:

int ubi_get_device_info(int ubi_num, struct ubi_device_info *di)
{
        const struct ubi_device *ubi;

        if (!try_module_get(THIS_MODULE))
                return -ENODEV;

        if (ubi_num < 0 || ubi_num >= UBI_MAX_DEVICES ||
            !ubi_devices[ubi_num]) {
                module_put(THIS_MODULE);
                return -ENODEV;
        }

        ubi = ubi_devices[ubi_num];
        di->ubi_num = ubi->ubi_num;
        di->leb_size = ubi->leb_size;
        di->min_io_size = ubi->min_io_size;
        di->ro_mode = ubi->ro_mode;
        di->cdev = MKDEV(ubi->major, 0);
        module_put(THIS_MODULE);
        return 0;
}

My understanding is that this is not completely safe (we could be
preempted before try_modules_get gets executed) and that it is the
caller who should manipulate the refcounts. Am I missing something here?

Thank you in advance.

