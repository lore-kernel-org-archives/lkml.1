Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZFVLhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZFVLhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZFVLg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:36:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36816 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbZFVLg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:36:58 -0400
From: "Aggarwal, Anuj" <anuj.aggarwal@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@sirena.org.uk>
Date: Mon, 22 Jun 2009 17:06:36 +0530
Subject: Regulator enable called without increasing the use_count
Thread-Topic: Regulator enable called without increasing the use_count
Thread-Index: AcnzLbNVYQu3ZrEARfCKty5jcFcbZA==
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0305AE7362@dbde02.ent.ti.com>
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

Hi,

In set_machine_constraints(), for regulators which are enabled at boot 
time, ops->enable() is called. But use_count is not increased, as was done
in regulator_enable(). Because of this, I cannot call regulator_disable()
on this regulator, even if it is enabled by default and I want to disable
it now. The framework throws me the following error:

<4>------------[ cut here ]------------
------------[ cut here ]------------
<4>WARNING: at drivers/regulator/core.c:1165 _regulator_disable+0x44/0x104()
WARNING: at drivers/regulator/core.c:1165 _regulator_disable+0x44/0x104()
unbalanced disables for LDO1
unbalanced disables for LDO1
Modules linked in:Modules linked in: tps_test(+) tps_test(+)

[<c0032ea4>] [<c0032ea4>] (dump_stack+0x0/0x14) (dump_stack+0x0/0x14) from [<c00
5ad30>] from [<c005ad30>] (warn_slowpath+0x6c/0x88)
(warn_slowpath+0x6c/0x88)
[<c005acc4>] [<c005acc4>] (warn_slowpath+0x0/0x88) (warn_slowpath+0x0/0x88) from
 [<c01992d8>] from [<c01992d8>] (_regulator_disable+0x44/0x104)
(_regulator_disable+0x44/0x104)
 r3:c03b72ef r3:c03b72ef r2:c03b6cac r2:c03b6cac

 r7:00000000 r7:00000000 r6:00000014 r6:00000014 r5:fffffffb r5:fffffffb r4:c70e
ce00 r4:c70ece00

[<c0199294>] [<c0199294>] (_regulator_disable+0x0/0x104) (_regulator_disable+0x0
/0x104) from [<c0199468>] from [<c0199468>] (regulator_disable+0x24/0x38)
(regulator_disable+0x24/0x38)
 r5:c70ece38 r5:c70ece38 r4:c70ece00 r4:c70ece00

[<c0199444>] [<c0199444>] (regulator_disable+0x0/0x38) (regulator_disable+0x0/0x
38) from [<bf0000cc>] from [<bf0000cc>] (test_tps65023+0xcc/0x150 [tps_test])
(test_tps65023+0xcc/0x150 [tps_test])
 r5:00000000 r5:00000000 r4:c729bce0 r4:c729bce0

[<bf000000>] [<bf000000>] (test_tps65023+0x0/0x150 [tps_test]) (test_tps65023+0x
0/0x150 [tps_test]) from [<bf003030>] from [<bf003030>] (tps_regulator_test_init
+0x30/0x48 [tps_test])
(tps_regulator_test_init+0x30/0x48 [tps_test])
 r6:c0433e20 r6:c0433e20 r5:bf000900 r5:bf000900 r4:00006ee1 r4:00006ee1

[<bf003000>] [<bf003000>] (tps_regulator_test_init+0x0/0x48 [tps_test]) (tps_reg
ulator_test_init+0x0/0x48 [tps_test]) from [<c002e2b0>] from [<c002e2b0>] (do_on
e_initcall+0x58/0x184)
(do_one_initcall+0x58/0x184)
[<c002e258>] [<c002e258>] (do_one_initcall+0x0/0x184) (do_one_initcall+0x0/0x184
) from [<c007e1d8>] from [<c007e1d8>] (sys_init_module+0x98/0x198)
(sys_init_module+0x98/0x198)
[<c007e140>] [<c007e140>] (sys_init_module+0x0/0x198) (sys_init_module+0x0/0x198
) from [<c002ee00>] from [<c002ee00>] (ret_fast_syscall+0x0/0x2c)
(ret_fast_syscall+0x0/0x2c)
 r7:00000080 r7:00000080 r6:00016f85 r6:00016f85 r5:beb33f04 r5:beb33f04 r4:0000
6ee1 r4:00006ee1

<4>---[ end trace fd7133e282dc9996 ]---
---[ end trace fd7133e282dc9996 ]---


Why is it designed like that? Should I enable it again and then call the 
disable()?

Regards,
Anuj Aggarwal

