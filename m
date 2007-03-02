Return-Path: <linux-kernel-owner+w=401wt.eu-S1422669AbXCBCJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422669AbXCBCJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422668AbXCBCJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:09:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35182 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422669AbXCBCJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:09:39 -0500
Date: Thu, 1 Mar 2007 18:09:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, a.zummo@towertech.it,
       David Brownell <david-b@pacbell.net>
Subject: Re: [patch take 2] Re: linux-2.6.today: rtc_cmos init oops/panic in
 rtc_sysfs_remove_device()
Message-Id: <20070301180925.c71c18a0.akpm@linux-foundation.org>
In-Reply-To: <1172739306.6709.27.camel@Homer.simpson.net>
References: <1171967177.6939.10.camel@Homer.simpson.net>
	<1172392313.6888.23.camel@Homer.simpson.net>
	<1172568305.7009.39.camel@Homer.simpson.net>
	<1172739306.6709.27.camel@Homer.simpson.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 09:55:06 +0100
Mike Galbraith <efault@gmx.de> wrote:

> Dummy here created a use after free.
> 
> Fix NULL pointer dereference in cmos_rtc registration failure path.
> Since we're freeing rtc in rtc_device_release(), there should be no need
> to NULL rtc->ops.  Anybody who has a reference to the freed rtc after
> device release, and uses it, will hopefully explode violently.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 7a0d8ee..d338fb8 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -113,9 +113,6 @@ EXPORT_SYMBOL_GPL(rtc_device_register);
>   */
>  void rtc_device_unregister(struct rtc_device *rtc)
>  {
> -	mutex_lock(&rtc->ops_lock);
> -	rtc->ops = NULL;
> -	mutex_unlock(&rtc->ops_lock);
>  	class_device_unregister(&rtc->class_dev);
>  }
>  EXPORT_SYMBOL_GPL(rtc_device_unregister);

Linus today merged the below, which I cunningly forgot to cc you on.

Can you please review current mainline, see if we still need fixes?

Thanks.


From: David Brownell <david-b@pacbell.net>

Fix an oops on the rtc_device_unregister() path by waiting until the last
moment before nulling the rtc->ops vector.  Fix some potential oopses by
having the rtc_class_open()/rtc_class_close() interface increase the RTC's
reference count while an RTC handle is available outside the RTC framework.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c     |   14 ++++++++++----
 drivers/rtc/interface.c |    3 ++-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/class.c~rtc_cmos-oops-fix drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc_cmos-oops-fix
+++ a/drivers/rtc/class.c
@@ -113,10 +113,16 @@ EXPORT_SYMBOL_GPL(rtc_device_register);
  */
 void rtc_device_unregister(struct rtc_device *rtc)
 {
-	mutex_lock(&rtc->ops_lock);
-	rtc->ops = NULL;
-	mutex_unlock(&rtc->ops_lock);
-	class_device_unregister(&rtc->class_dev);
+	if (class_device_get(&rtc->class_dev) != NULL) {
+		mutex_lock(&rtc->ops_lock);
+		/* remove innards of this RTC, then disable it, before
+		 * letting any rtc_class_open() users access it again
+		 */
+		class_device_unregister(&rtc->class_dev);
+		rtc->ops = NULL;
+		mutex_unlock(&rtc->ops_lock);
+		class_device_put(&rtc->class_dev);
+	}
 }
 EXPORT_SYMBOL_GPL(rtc_device_unregister);
 
diff -puN drivers/rtc/interface.c~rtc_cmos-oops-fix drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc_cmos-oops-fix
+++ a/drivers/rtc/interface.c
@@ -179,7 +179,7 @@ struct class_device *rtc_class_open(char
 	down(&rtc_class->sem);
 	list_for_each_entry(class_dev_tmp, &rtc_class->children, node) {
 		if (strncmp(class_dev_tmp->class_id, name, BUS_ID_SIZE) == 0) {
-			class_dev = class_dev_tmp;
+			class_dev = class_device_get(class_dev_tmp);
 			break;
 		}
 	}
@@ -197,6 +197,7 @@ EXPORT_SYMBOL_GPL(rtc_class_open);
 void rtc_class_close(struct class_device *class_dev)
 {
 	module_put(to_rtc_device(class_dev)->owner);
+	class_device_put(class_dev);
 }
 EXPORT_SYMBOL_GPL(rtc_class_close);
 
_

