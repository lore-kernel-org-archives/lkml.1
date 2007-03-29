Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXC2IL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXC2IL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 04:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934021AbXC2IL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 04:11:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:40805 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933585AbXC2IL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 04:11:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ni7agyOuZkyQap2vrR7DXeCw3r4sgkCvui8FyS68oGxxi0pwu8gz8MTJAKOgtCoAmxPrrbgR+WBPdA1wcE4UN6oDqFafmHGC5Zn9yORo0zj1+1HP8YZEFMIBcCwbNohs7OTXDng8v9gBeKSa1seAJdr8hwbxr62N5Y7oKhp3kWI=
Message-ID: <2375c9f90703290111k1e72510eu1c2fbc13035123eb@mail.gmail.com>
Date: Thu, 29 Mar 2007 16:11:25 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: linwy@mail.ustc.edu.cn, linux-kernel@vger.kernel.org
Subject: Re: a question about kernel copy userspace data
In-Reply-To: <375153397.05466@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <375153397.05466@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/29, linwy@mail.ustc.edu.cn <linwy@mail.ustc.edu.cn>:
> hello ,
> i am programming a trial firewall based on netfilter ,which needs the module to
> access the data of user space ,so i use copy_from_user() but it can't work ,the
> code(simple test code) is like this:
> -------user space program-----
> #include <stdlib.h>
> #include <stdio.h>
>

You forgot to #include <string.h>, because you used 'strcat' below.

> int main(int argc ,char *argv[]) {
> char para[100]="insmod test.ko ";
> int c=24;
> unsigned int point=&c;

Bad code. 'unsigned int' is _not_ enough to hold a pointer on 64-bit
machines. Try 'unsigned long' please.

> printf("%u\n",point);
> char b[11]="0000000000"; /*convert the unsigned to chars */
> int j=10;
> int siz=0;
> while(point>0) {
> b[--j]=point%10+48;
> point=point/10;
> siz++;
> }
> char ips[30]="point=";
> strcat(ips,&b[10-siz]);
> strcat(para,ips);
> puts(para);
> system("make");
> system(para);

return 0;

> }

Why don't you try to use a shell/Perl/Python script instead? C is
_not_ good at this.

> -------kernel module-----------
> #include <linux/module.h>
> #include <linux/netfilter_ipv4.h>
> #include <linux/tcp.h>
> #include <linux/moduleparam.h>
>
> MODULE_LICENSE("Dual BSD/GPL");
>
> static unsigned int *point;
> module_param(point, uint , S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
> MODULE_PARM_DESC(point, "the pointer of user space");
>
> static unsigned int
> linuxmag_hook(unsigned int hook, struct sk_buff **pskb,
> const struct net_device *indev, const
> struct net_device *outdev, int
> (*okfn)(struct sk_buff *))
> {
> printk("world\n");
> printk(" %u\n",point);
> int *b;
> b=kmalloc(sizeof(int),GFP_KERNEL);

Please ALWAYS check the return value of 'kmalloc'.
ps. What prevents you to define an 'int' instead of defining a pointer
first then alloc memory?

> copy_from_user(b,(int *)point,sizeof(int));
> printk("user space's value=%u\n",*b);
> }
>
> static struct nf_hook_ops linuxmag_ops
> = { .hook = linuxmag_hook,
> .owner = THIS_MODULE,
> .pf = PF_INET,
> .hooknum = NF_IP_LOCAL_OUT,
> .priority = NF_IP_PRI_FILTER-1
> };
>
> static int __init init(void)
> {
> return nf_register_hook(&linuxmag_ops);
> }
>
> static void __exit fini(void)
> {
> nf_unregister_hook(&linuxmag_ops);
> }
> module_init(init);
> module_exit(fini);
>
> i check the /var/log/messages.
>  the user space's value is 0
> not the right value 24 which i defined in main().
> this question puzzled me for a few days,and i am a fresh man about  kernel.is
> there anyone can help me?
> any answer would be appreciated very much .
>




-- 
So Dark The Con Of Man.
