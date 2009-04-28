Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbZD1C77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbZD1C77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759374AbZD1C7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:59:42 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:47991 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759350AbZD1C7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:59:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=U2SkFIBxoP6vfC/KGQqWz4tCOPIg85qk6LOh7X0s1YioGyUGJRkQRYjiuD+v33+LIBz/r9oLCLb+FcGGNBIBjQ+cF055A+EPWxP9mT1pINSpU0yqlDGycelcX9aQKbQ2r0eqv3q7+Or4ZG7pX1OgrzKHjYhorg6oCso9lpwKYek=  ;
X-YMail-OSG: Dp0flBUVM1nhcvkS2wFdQC6TZ5ELD8lDO1xUGGlapSmX4uq928DNv1_rQYzUPn3gn6jJ3Vxc_o1zvpZYUssKPm8aqPHdCpmP1ImJCjamJRx8LkXO7Uq2HPrUJ4MrXB6oLvFibwGF3st9Lo_BJXwLMnQHk5pwG9qwUxLzOq9_VUQpNxrQXCOc3BT36gEWxvDd.HYVM2eNDbTeZB9y1ou01oRFxKkbk9vMsrBHokl9jeQKtFJj8LU0cLc7NE6yuk_8uqwoP8z3JFRHdho6LxFc6txbkiXPTYfnF4tcaO2zcZYPVBD5IPzWwtx8xw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>, Liam Girdwood <lrg@slimlogic.co.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.30-rc3] regulator: regression fix
Date: Mon, 27 Apr 2009 19:59:40 -0700
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271959.40526.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Revert the "Don't warn on omitted voltage constraints" patch
(3e2b9abda554e9f6105996dca77cca9ef98de17a), which doesn't do
quite what its comments said it was doing.

By removing the "else", it breaks the handling of fixed-voltage
regulators ... turning a non-error/non-warning situation into
a complete init failure, which can then prevent system startup.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
You might want to provide a different patch, but ignoring
this regression doesn't seem practical...

 drivers/regulator/core.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -709,12 +709,8 @@ static int set_machine_constraints(struc
 			cmax = INT_MAX;
 		}
 
-		/* voltage constraints are optional */
-		if ((cmin == 0) && (cmax == 0))
-			goto out;
-
 		/* else require explicit machine-level constraints */
-		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
+		else if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
 			pr_err("%s: %s '%s' voltage constraints\n",
 				       __func__, "invalid", name);
 			ret = -EINVAL;
