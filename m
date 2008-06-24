Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbYFXNUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbYFXNUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYFXNUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:20:09 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:52252 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYFXNUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:20:07 -0400
Date: Tue, 24 Jun 2008 15:20:04 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 0/2]v2 configfs: symlink() fixes
Message-ID: <20080624132004.GF7621@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1214223378-14203-1-git-send-email-louis.rilling@kerlabs.com> <20080623222043.GG592@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-24344-1214313511-0001-2"
Content-Disposition: inline
In-Reply-To: <20080623222043.GG592@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-24344-1214313511-0001-2
Content-Type: multipart/mixed; boundary="bO4vSxwwZtUjUWHo"
Content-Disposition: inline


--bO4vSxwwZtUjUWHo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2008 at 03:20:44PM -0700, Joel Becker wrote:
> On Mon, Jun 23, 2008 at 02:16:16PM +0200, Louis Rilling wrote:
> > The following patchset fixes incorrect symlinks to dead items in config=
fs, which
> > are forbidden by specification.
> >=20
> > The first patch actually prevents such dangling symlinks from being cre=
ated, but
> > introduces a weird(?) behavior where a failing symlink() can make a rac=
ing
> > rmdir() fail in the symlink's parent and in the symlink's target as wel=
l. This
> > behavior is fixed with the next patch.
>=20
> 	Silly question: you've tested this, right?

Yup. I tested this on Linux 2.6.26-rc5 with a modified example_configfs.c
(attached), and on a backport for 2.6.20 with my own subsystem (based on
Kerrighed http://www.kerrighed.org/wiki/index.php/SchedConfig ).

Do you have some regression tests?

sample tests for symlinks:

mkdir -p /config/03-group-children/c1/c1.1
cd /config/03-group-children/c1/c1.1

# repeatedly create and remove a symlink to self
ln -s . link
rm link
ln -s . link
rm link

mkdir /config/02-simple-children/c2

# repeatedly create and remove a symlink to another item
ln -s /config/02-simple-children/c2 link
rm link
ln -s /config/02-simple-children/c2 link
rm link

# create two links with inverted source and target
ln -s /config/02-simple-children/c2 link
ln -s . /config/02-simple-children/c2/link
rm link
rm /config/02-simple-children/c2/link

# try hard to create a link to a removed item
# last loop is to be run in a separate shell
cd /config/03-group-children/c1
while true; do mkdir c1.1 && echo mkdir ok; rmdir c1.1 && echo rmdir ok; do=
ne
# in a separate shell
cd /config/02-simple-children/c2
while true; do ln -s /config/03-group-children/c1/c1.1 link && echo ln ok &=
& \
(ls link/ || (echo failed!!!; read foo)) && rm link; done

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--bO4vSxwwZtUjUWHo
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="configfs_example.c"

/*
 * vim: noexpandtab ts=8 sts=0 sw=8:
 *
 * configfs_example.c - This file is a demonstration module containing
 *      a number of configfs subsystems.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 021110-1307, USA.
 *
 * Based on sysfs:
 * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
 *
 * configfs Copyright (C) 2005 Oracle.  All rights reserved.
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>

#include <linux/configfs.h>



/*
 * 01-childless
 *
 * This first example is a childless subsystem.  It cannot create
 * any config_items.  It just has attributes.
 *
 * Note that we are enclosing the configfs_subsystem inside a container.
 * This is not necessary if a subsystem has no attributes directly
 * on the subsystem.  See the next example, 02-simple-children, for
 * such a subsystem.
 */

struct childless {
	struct configfs_subsystem subsys;
	int showme;
	int storeme;
};

struct childless_attribute {
	struct configfs_attribute attr;
	ssize_t (*show)(struct childless *, char *);
	ssize_t (*store)(struct childless *, const char *, size_t);
};

static inline struct childless *to_childless(struct config_item *item)
{
	return item ? container_of(to_configfs_subsystem(to_config_group(item)), struct childless, subsys) : NULL;
}

static ssize_t childless_showme_read(struct childless *childless,
				     char *page)
{
	ssize_t pos;

	pos = sprintf(page, "%d\n", childless->showme);
	childless->showme++;

	return pos;
}

static ssize_t childless_storeme_read(struct childless *childless,
				      char *page)
{
	return sprintf(page, "%d\n", childless->storeme);
}

static ssize_t childless_storeme_write(struct childless *childless,
				       const char *page,
				       size_t count)
{
	unsigned long tmp;
	char *p = (char *) page;

	tmp = simple_strtoul(p, &p, 10);
	if (!p || (*p && (*p != '\n')))
		return -EINVAL;

	if (tmp > INT_MAX)
		return -ERANGE;

	childless->storeme = tmp;

	return count;
}

static ssize_t childless_description_read(struct childless *childless,
					  char *page)
{
	return sprintf(page,
"[01-childless]\n"
"\n"
"The childless subsystem is the simplest possible subsystem in\n"
"configfs.  It does not support the creation of child config_items.\n"
"It only has a few attributes.  In fact, it isn't much different\n"
"than a directory in /proc.\n");
}

static struct childless_attribute childless_attr_showme = {
	.attr	= { .ca_owner = THIS_MODULE, .ca_name = "showme", .ca_mode = S_IRUGO },
	.show	= childless_showme_read,
};
static struct childless_attribute childless_attr_storeme = {
	.attr	= { .ca_owner = THIS_MODULE, .ca_name = "storeme", .ca_mode = S_IRUGO | S_IWUSR },
	.show	= childless_storeme_read,
	.store	= childless_storeme_write,
};
static struct childless_attribute childless_attr_description = {
	.attr = { .ca_owner = THIS_MODULE, .ca_name = "description", .ca_mode = S_IRUGO },
	.show = childless_description_read,
};

static struct configfs_attribute *childless_attrs[] = {
	&childless_attr_showme.attr,
	&childless_attr_storeme.attr,
	&childless_attr_description.attr,
	NULL,
};

static ssize_t childless_attr_show(struct config_item *item,
				   struct configfs_attribute *attr,
				   char *page)
{
	struct childless *childless = to_childless(item);
	struct childless_attribute *childless_attr =
		container_of(attr, struct childless_attribute, attr);
	ssize_t ret = 0;

	if (childless_attr->show)
		ret = childless_attr->show(childless, page);
	return ret;
}

static ssize_t childless_attr_store(struct config_item *item,
				    struct configfs_attribute *attr,
				    const char *page, size_t count)
{
	struct childless *childless = to_childless(item);
	struct childless_attribute *childless_attr =
		container_of(attr, struct childless_attribute, attr);
	ssize_t ret = -EINVAL;

	if (childless_attr->store)
		ret = childless_attr->store(childless, page, count);
	return ret;
}

static struct configfs_item_operations childless_item_ops = {
	.show_attribute		= childless_attr_show,
	.store_attribute	= childless_attr_store,
};

static struct config_item_type childless_type = {
	.ct_item_ops	= &childless_item_ops,
	.ct_attrs	= childless_attrs,
	.ct_owner	= THIS_MODULE,
};

static struct childless childless_subsys = {
	.subsys = {
		.su_group = {
			.cg_item = {
				.ci_namebuf = "01-childless",
				.ci_type = &childless_type,
			},
		},
	},
};


/* ----------------------------------------------------------------- */

/*
 * 02-simple-children
 *
 * This example merely has a simple one-attribute child.  Note that
 * there is no extra attribute structure, as the child's attribute is
 * known from the get-go.  Also, there is no container for the
 * subsystem, as it has no attributes of its own.
 */

struct simple_child {
	struct config_item item;
	int storeme;
};

static inline struct simple_child *to_simple_child(struct config_item *item)
{
	return item ? container_of(item, struct simple_child, item) : NULL;
}

static struct configfs_attribute simple_child_attr_storeme = {
	.ca_owner = THIS_MODULE,
	.ca_name = "storeme",
	.ca_mode = S_IRUGO | S_IWUSR,
};

static struct configfs_attribute *simple_child_attrs[] = {
	&simple_child_attr_storeme,
	NULL,
};

static ssize_t simple_child_attr_show(struct config_item *item,
				      struct configfs_attribute *attr,
				      char *page)
{
	ssize_t count;
	struct simple_child *simple_child = to_simple_child(item);

	count = sprintf(page, "%d\n", simple_child->storeme);

	return count;
}

static ssize_t simple_child_attr_store(struct config_item *item,
				       struct configfs_attribute *attr,
				       const char *page, size_t count)
{
	struct simple_child *simple_child = to_simple_child(item);
	unsigned long tmp;
	char *p = (char *) page;

	tmp = simple_strtoul(p, &p, 10);
	if (!p || (*p && (*p != '\n')))
		return -EINVAL;

	if (tmp > INT_MAX)
		return -ERANGE;

	simple_child->storeme = tmp;

	return count;
}

static void simple_child_release(struct config_item *item)
{
	kfree(to_simple_child(item));
}

/* Forward declaration */
static struct config_item_type simple_child_type;

static int simple_child_allow_link(struct config_item *src,
				   struct config_item *target)
{
	return (target->ci_type == &simple_child_type) ? 0 : -EPERM;
}

static struct configfs_item_operations simple_child_item_ops = {
	.release		= simple_child_release,
	.show_attribute		= simple_child_attr_show,
	.store_attribute	= simple_child_attr_store,
	.allow_link		= simple_child_allow_link,
};

static struct config_item_type simple_child_type = {
	.ct_item_ops	= &simple_child_item_ops,
	.ct_attrs	= simple_child_attrs,
	.ct_owner	= THIS_MODULE,
};


struct simple_children {
	struct config_group group;
};

static inline struct simple_children *to_simple_children(struct config_item *item)
{
	return item ? container_of(to_config_group(item), struct simple_children, group) : NULL;
}

static struct config_item *simple_children_make_item(struct config_group *group, const char *name)
{
	struct simple_child *simple_child;

	simple_child = kzalloc(sizeof(struct simple_child), GFP_KERNEL);
	if (!simple_child)
		return NULL;


	config_item_init_type_name(&simple_child->item, name,
				   &simple_child_type);

	simple_child->storeme = 0;

	return &simple_child->item;
}

static struct configfs_attribute simple_children_attr_description = {
	.ca_owner = THIS_MODULE,
	.ca_name = "description",
	.ca_mode = S_IRUGO,
};

static struct configfs_attribute *simple_children_attrs[] = {
	&simple_children_attr_description,
	NULL,
};

static ssize_t simple_children_attr_show(struct config_item *item,
			   		 struct configfs_attribute *attr,
			   		 char *page)
{
	return sprintf(page,
"[02-simple-children]\n"
"\n"
"This subsystem allows the creation of child config_items.  These\n"
"items have only one attribute that is readable and writeable.\n");
}

static void simple_children_release(struct config_item *item)
{
	kfree(to_simple_children(item));
}

static struct configfs_item_operations simple_children_item_ops = {
	.release 	= simple_children_release,
	.show_attribute	= simple_children_attr_show,
};

/*
 * Note that, since no extra work is required on ->drop_item(),
 * no ->drop_item() is provided.
 */
static struct configfs_group_operations simple_children_group_ops = {
	.make_item	= simple_children_make_item,
};

static struct config_item_type simple_children_type = {
	.ct_item_ops	= &simple_children_item_ops,
	.ct_group_ops	= &simple_children_group_ops,
	.ct_attrs	= simple_children_attrs,
	.ct_owner	= THIS_MODULE,
};

static struct configfs_subsystem simple_children_subsys = {
	.su_group = {
		.cg_item = {
			.ci_namebuf = "02-simple-children",
			.ci_type = &simple_children_type,
		},
	},
};


/* ----------------------------------------------------------------- */

/*
 * 03-group-children
 *
 * This example reuses the simple_children group from above.  However,
 * the simple_children group is not the subsystem itself, it is a
 * child of the subsystem.  Creation of a group in the subsystem creates
 * a new simple_children group.  That group can then have simple_child
 * children of its own.
 */

static struct config_group *group_children_make_group(struct config_group *group, const char *name)
{
	struct simple_children *simple_children;

	simple_children = kzalloc(sizeof(struct simple_children),
				  GFP_KERNEL);
	if (!simple_children)
		return NULL;


	config_group_init_type_name(&simple_children->group, name,
				    &simple_children_type);

	return &simple_children->group;
}

static struct configfs_attribute group_children_attr_description = {
	.ca_owner = THIS_MODULE,
	.ca_name = "description",
	.ca_mode = S_IRUGO,
};

static struct configfs_attribute *group_children_attrs[] = {
	&group_children_attr_description,
	NULL,
};

static ssize_t group_children_attr_show(struct config_item *item,
			   		struct configfs_attribute *attr,
			   		char *page)
{
	return sprintf(page,
"[03-group-children]\n"
"\n"
"This subsystem allows the creation of child config_groups.  These\n"
"groups are like the subsystem simple-children.\n");
}

static struct configfs_item_operations group_children_item_ops = {
	.show_attribute	= group_children_attr_show,
};

/*
 * Note that, since no extra work is required on ->drop_item(),
 * no ->drop_item() is provided.
 */
static struct configfs_group_operations group_children_group_ops = {
	.make_group	= group_children_make_group,
};

static struct config_item_type group_children_type = {
	.ct_item_ops	= &group_children_item_ops,
	.ct_group_ops	= &group_children_group_ops,
	.ct_attrs	= group_children_attrs,
	.ct_owner	= THIS_MODULE,
};

static struct configfs_subsystem group_children_subsys = {
	.su_group = {
		.cg_item = {
			.ci_namebuf = "03-group-children",
			.ci_type = &group_children_type,
		},
	},
};

/* ----------------------------------------------------------------- */

/*
 * We're now done with our subsystem definitions.
 * For convenience in this module, here's a list of them all.  It
 * allows the init function to easily register them.  Most modules
 * will only have one subsystem, and will only call register_subsystem
 * on it directly.
 */
static struct configfs_subsystem *example_subsys[] = {
	&childless_subsys.subsys,
	&simple_children_subsys,
	&group_children_subsys,
	NULL,
};

static int __init configfs_example_init(void)
{
	int ret;
	int i;
	struct configfs_subsystem *subsys;

	for (i = 0; example_subsys[i]; i++) {
		subsys = example_subsys[i];

		config_group_init(&subsys->su_group);
		mutex_init(&subsys->su_mutex);
		ret = configfs_register_subsystem(subsys);
		if (ret) {
			printk(KERN_ERR "Error %d while registering subsystem %s\n",
			       ret,
			       subsys->su_group.cg_item.ci_namebuf);
			goto out_unregister;
		}
	}

	return 0;

out_unregister:
	for (; i >= 0; i--) {
		configfs_unregister_subsystem(example_subsys[i]);
	}

	return ret;
}

static void __exit configfs_example_exit(void)
{
	int i;

	for (i = 0; example_subsys[i]; i++) {
		configfs_unregister_subsystem(example_subsys[i]);
	}
}

module_init(configfs_example_init);
module_exit(configfs_example_exit);
MODULE_LICENSE("GPL");


--bO4vSxwwZtUjUWHo--

--=_bohort-24344-1214313511-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIYPSEVKcRuvQ9Q1QRAhpdAJ97Z78Xp3V6b0Ue+461hZrWNB1powCfbOHq
szDYWw7CeZ+Q3oNdv4iKosY=
=GnJu
-----END PGP SIGNATURE-----

--=_bohort-24344-1214313511-0001-2--
