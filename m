Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbXKFJ45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbXKFJ45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbXKFJ4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:56:50 -0500
Received: from sacred.ru ([62.205.161.221]:47613 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbXKFJ4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:56:49 -0500
Message-ID: <473031FA.2060707@openvz.org>
Date: Tue, 06 Nov 2007 12:20:58 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Module init call vs symbols exporting race?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 06 Nov 2007 12:56:35 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I looked at the sys_init_module() and found that the ->init callback
for the module is called without the module_mutex held and *after*
the module's symbols are exported. Doesn't this create the race when
loading two modules in parallel? Like this.

Consider the first module to be (without any internal locking for
simplicity)

=== foo.c ===
static struct list_head foo_list;

void foo_register(struct list_head *elem)
{
	list_add(elem, &foo_list);
}
EXPORT_SYMBOL(foo_register);

static int foo_init(void)
{
	INIT_LIST_HEAD(&foo_list);
}
module_init(foo_init);
===

and the second one

=== bar.c ===
struct bar_struct {
	struct list_head list;
	...
} bar;

static int bar_init(void)
{
	foo_register(&bar.list);
}
module_init(bar_init);
===

If I understand the sys_init_module() right, the following code
flow is possible:

1CPU                                        2CPU
sys_init_module(/* foo module */)           sys_init_module(/* bar module */)
  mutex_lock(&module_mutex);
  load_module();
      /* export the foo_init here */
  mutex_unlock(&module_mutex);
                                            mutex_lock(&module_mutex);
                                            load_module();
                                                /* resolve the foo_init here */
                                            mutex_unlock(&mudule_mutex);
                                            mod->init(); /* bar_init */
           /*
            * OOPS! The foo_list is not ready yet, because the foo_init
            * is not called yet.
            */
  mod->init(); /* foo_init... too late */

Is this analysis correct?

Thanks,
Pavel
