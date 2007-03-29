Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbXC2HjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbXC2HjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 03:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXC2HjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 03:39:15 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:39360 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753300AbXC2HjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 03:39:14 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2007 03:37:48 EDT
Message-ID: <375153397.05466@ustc.edu.cn>
X-WebMAIL-MUA: [210.45.119.241]
From: "" <linwy@mail.ustc.edu.cn>
To: linux-kernel@vger.kernel.org
Date: Thu, 29 Mar 2007 15:29:57 +0800
Reply-To: "" <linwy@mail.ustc.edu.cn>
X-Priority: 3
Subject: a question about kernel copy userspace data
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello ,
i am programming a trial firewall based on netfilter ,which needs the module to
access the data of user space ,so i use copy_from_user() but it can't work ,the
code(simple test code) is like this:
-------user space program-----
#include <stdlib.h>
#include <stdio.h>

int main(int argc ,char *argv[]) {
char para[100]="insmod test.ko ";
int c=24;
unsigned int point=&c;
printf("%u\n",point);
char b[11]="0000000000"; /*convert the unsigned to chars */
int j=10;
int siz=0;
while(point>0) {
b[--j]=point%10+48;
point=point/10;
siz++;
}
char ips[30]="point=";
strcat(ips,&b[10-siz]);
strcat(para,ips);
puts(para);
system("make");
system(para);
}
-------kernel module-----------
#include <linux/module.h>
#include <linux/netfilter_ipv4.h>
#include <linux/tcp.h>
#include <linux/moduleparam.h>

MODULE_LICENSE("Dual BSD/GPL");

static unsigned int *point;
module_param(point, uint , S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
MODULE_PARM_DESC(point, "the pointer of user space");

static unsigned int
linuxmag_hook(unsigned int hook, struct sk_buff **pskb,
const struct net_device *indev, const
struct net_device *outdev, int
(*okfn)(struct sk_buff *))
{
printk("world\n");
printk(" %u\n",point);
int *b;
b=kmalloc(sizeof(int),GFP_KERNEL);
copy_from_user(b,(int *)point,sizeof(int));
printk("user space's value=%u\n",*b);
}

static struct nf_hook_ops linuxmag_ops
= { .hook = linuxmag_hook,
.owner = THIS_MODULE,
.pf = PF_INET,
.hooknum = NF_IP_LOCAL_OUT,
.priority = NF_IP_PRI_FILTER-1
};

static int __init init(void)
{
return nf_register_hook(&linuxmag_ops);
}

static void __exit fini(void)
{
nf_unregister_hook(&linuxmag_ops);
}
module_init(init);
module_exit(fini);

i check the /var/log/messages.
 the user space's value is 0
not the right value 24 which i defined in main().
this question puzzled me for a few days,and i am a fresh man about  kernel.is
there anyone can help me?
any answer would be appreciated very much .


